require 'net/http'
require 'json'

require_relative '../lib/infrastructure/project_manager'
require_relative '../lib/infrastructure/project_model'
require_relative '../lib/appstore/rate_calculator'
require_relative '../lib/appstore/review_service'
require_relative '../lib/appstore/version_determinator'

SCHEDULER.every '1d', :first_in => 0 do |job|
  project_manager = Infrastructure::ProjectManager.new
  project_manager.obtain_all_projects.each do |project|
    service = AppStore::ReviewService.new
    reviews = service.obtain_reviews_for_app_id(project.appstore_id)

  end
end