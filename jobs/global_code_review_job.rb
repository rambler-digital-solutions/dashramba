require_relative '../lib/global_code_review/global_code_review_service'
require_relative '../lib/global_code_review/global_code_review_model'
require_relative '../lib/infrastructure/project_manager'
require_relative '../lib/infrastructure/project_model'

SCHEDULER.every '1d', :first_in => 0 do |job|
  service = GlobalCodeReview::GlobalCodeReviewService.new

  project_manager = Infrastructure::ProjectManager.new
  project_manager.obtain_all_projects.each do |project|
    next unless project.google_code_review_cell_id != nil
    cell_id = project.google_code_review_cell_id
    service.fetch_review_status_for_cell_id(cell_id)
    model = service.obtain_review_status_for_cell_id(cell_id)
    review_date = Date.parse(model.date)
    number_of_days = Date.today.mjd - review_date.mjd

    widget_name = "google_spreadsheet_#{project.jenkins_name}"
    puts(widget_name)
    send_event(widget_name, {
                              'days' => number_of_days
                          })
  end
end