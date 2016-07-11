require 'net/http'
require 'json'

require_relative '../lib/infrastructure/project_manager'
require_relative '../lib/infrastructure/project_model'
require_relative '../lib/fabric/fabric_service'

SCHEDULER.every '2m', :first_in => 0 do |job|
  project_manager = Infrastructure::ProjectManager.new
  service = Fabric::FabricService.new
  crashfree_array = Array.new
  project_manager.obtain_all_projects.each do |project|
    next unless project.fabric_project_id != nil

    service.fetch_crashfree_for_bundle_id(project.fabric_project_id)
    model = service.obtain_crashfree_for_bundle_id(project.fabric_project_id)
    crashfree = model.crashfree if model != nil

    crashfree_percentage = "#{(crashfree * 100).round(1).to_s}%"
    project_hash = {
        :label => project.display_name,
        :value => crashfree_percentage
    }
    crashfree_array = crashfree_array.push(project_hash)

    widget_name = "fabric_#{project.appstore_id}"
    send_event(widget_name, { current: crashfree_percentage })
  end

  leaderboard_widget_name = 'crashfree-leaderboard'
  crashfree_array = crashfree_array.sort_by {|hash| hash[:value][/[0-9]*.?[0-9]*/].to_f}.reverse!
  send_event(leaderboard_widget_name, { items: crashfree_array })
end