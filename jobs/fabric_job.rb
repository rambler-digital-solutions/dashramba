require 'net/http'
require 'json'

require_relative '../lib/infrastructure/project_manager'
require_relative '../lib/infrastructure/project_model'
require_relative '../lib/fabric/fabric_service'

SCHEDULER.every '2m', :first_in => 0 do |job|
  project_manager = Infrastructure::ProjectManager.new
  service = Fabric::FabricService.new
  project_manager.obtain_all_projects.each do |project|
    next unless project.fabric_project_id != nil

    service.fetch_crashfree_for_bundle_id(project.fabric_project_id)
    model = service.obtain_crashfree_for_bundle_id(project.fabric_project_id)
    crashfree = model.crashfree if model != nil
    widget_name = "fabric_#{project.appstore_id}"
    send_event(widget_name, { current: crashfree })
  end
end