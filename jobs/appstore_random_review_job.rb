require 'net/http'
require 'json'

require_relative '../lib/infrastructure/project_manager'
require_relative '../lib/infrastructure/project_model'
require_relative '../lib/appstore/rate_calculator'
require_relative '../lib/appstore/review_service'
require_relative '../lib/appstore/version_determinator'

SCHEDULER.every '5s', :first_in => 0 do |job|
  project_manager = Infrastructure::ProjectManager.new
  project_manager.obtain_all_projects.each do |project|
    service = AppStore::ReviewService.new
    reviews = service.obtain_reviews_for_app_id(project.appstore_id)

    random_review = reviews.sample
    widget_name = "appstore_review_#{project.appstore_id}"
    send_event(widget_name, {
                              'author-name' => random_review.author_name,
                              'review-text' => random_review.text,
                              'rating' => random_review.rating
                          })
  end
end