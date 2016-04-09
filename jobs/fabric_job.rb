require 'net/http'
require 'json'

require_relative '../lib/infrastructure/project_manager'
require_relative '../lib/infrastructure/project_model'
require_relative '../lib/fabric/fabric_service'

SCHEDULER.every '10m', :first_in => 0 do |job|
  project_manager = Infrastructure::ProjectManager.new
  project_manager.obtain_all_projects.each do |project|
    service = Fabric::FabricService.new
    service.fetch_crashfree_for_bundle_id(project.bundle_id)

    model = service.obtain_crashfree_for_bundle_id(project.bundle_id)
    crashfree = model.crashfree if model != nil
    widget_name = "fabric_#{project.appstore_id}"
    send_event(widget_name, { current: crashfree })
  end
end