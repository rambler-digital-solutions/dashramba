require 'net/http'
require 'json'

require_relative '../lib/infrastructure/project_manager'
require_relative '../lib/infrastructure/project_model'
require_relative '../lib/fabric/fabric_service'
require_relative '../lib/fabric/fabric_model'

service = Fabric::FabricService.new

SCHEDULER.every '30s', :first_in => 0 do |job|
  project_manager = Infrastructure::ProjectManager.new
  crashfree_array = Array.new
  active_now_array = Array.new
  project_manager.obtain_all_projects.each do |project|
    next unless project.fabric_project_id != nil

    @service.fetch_crashfree_for_bundle_id(project.fabric_project_id)
    @service.fetch_active_now_for_bundle_id(project.fabric_project_id)
    model = service.obtain_fabric_model_for_bundle_id(project.fabric_project_id)
    if model != nil
      crashfree = model.average_monthly_crashfree
      active_now = model.active_now

      crashfree_percentage = "#{(crashfree * 100).round(1).to_s}%"
      crashfree_hash = {
          :label => project.display_name,
          :value => crashfree_percentage
      }

      active_now_hash = {
          :label => project.display_name,
          :value => active_now
      }

      crashfree_array = crashfree_array.push(crashfree_hash)
      active_now_array = active_now_array.push(active_now_hash)

      widget_name = "fabric_#{project.appstore_id}"
      send_event(widget_name, { current: crashfree_percentage })

      widget_name = "active_now_#{project.appstore_id}"
      send_event(widget_name, { current: active_now })
    end

  end

  leaderboard_widget_name = 'crashfree-leaderboard'
  crashfree_array = crashfree_array.sort_by {|hash| hash[:value][/[0-9]*.?[0-9]*/].to_f}.reverse!
  send_event(leaderboard_widget_name, { items: crashfree_array })

  active_now_leaderboard_widget_name = 'active-now-leaderboard'
  active_now_array = active_now_array.sort_by {|hash| hash[:value]}.reverse!
  send_event(active_now_leaderboard_widget_name, { items: active_now_array })
end