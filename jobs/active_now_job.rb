require_relative '../lib/infrastructure/project_manager'
require_relative '../lib/infrastructure/project_model'
require_relative '../lib/fabric/fabric_service'
require_relative '../lib/fabric/fabric_model'

SCHEDULER.every '10s', :first_in => 0 do |job|
  project_manager = Infrastructure::ProjectManager.new
  service = Fabric::FabricService.new
  active_now_array = Array.new
  project_manager.obtain_all_projects.each do |project|
    next unless project.fabric_project_id != nil

    service.fetch_active_now_for_bundle_id(project.fabric_project_id)
    model = service.obtain_fabric_model_for_bundle_id(project.fabric_project_id)
    if model != nil
      active_now = model.active_now

      project_hash = {
          :label => project.display_name,
          :value => active_now
      }
      active_now_array = active_now_array.push(project_hash)

      widget_name = "active_now_#{project.appstore_id}"
      send_event(widget_name, { current: active_now })
    end

  end

  active_now_leaderboard_widget_name = 'active-now-leaderboard'
  active_now_array = active_now_array.sort_by {|hash| hash[:value]}.reverse!
  send_event(active_now_leaderboard_widget_name, { items: active_now_array })
end