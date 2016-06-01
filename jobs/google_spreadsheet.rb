require_relative '../lib/google_drive/google_drive_service'
require_relative '../lib/infrastructure/project_manager'
require_relative '../lib/infrastructure/project_model'

REVIEW_WORKSHEET_NUMBER = 0
REVIEW_WORKSHEET_DATE_COLUMN = 3

SCHEDULER.every '10m', :first_in => 0 do |job|
  service = GoogleDrive::GoogleDriveService.new
  session = service.obtain_session
  spreadsheet_id = ENV['DASHING_TARGET_SPREAD_SHEET_ID']

  project_manager = Infrastructure::ProjectManager.new
  project_manager.obtain_all_projects.each do |project|
    next unless project.google_code_review_cell_id != nil
    review_date_string = service.obtain_spreadsheet_value(session,
                                                   spreadsheet_id,
                                                   REVIEW_WORKSHEET_NUMBER,
                                                   project.google_code_review_cell_id)
    review_date = Date.parse(review_date_string)
    number_of_days = Date.today.mjd - review_date.mjd
    if number_of_days > 100
      result_string = 'Слишком давно'
    else
      result_string = "#{number_of_days.to_s} дн. назад"
    end

    widget_name = "google_spreadsheet_#{project.jenkins_name}"
    puts(widget_name)
    send_event(widget_name, {
                              'current' => result_string
                          })

    puts(result_string)
  end


end