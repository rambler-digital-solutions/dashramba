require 'json'
require_relative '../lib/jenkins/jenkins_service'

SCHEDULER.every '1h', :first_in => 0 do
    projects_array = []
    service = Jenkins::JenkinsService.new
    project_manager = Infrastructure::ProjectManager.new
    project_manager.obtain_all_projects.each do |project|
      name = project.jenkins_name
      next until name != nil

      tests_count = service.fetch_tests_count(name)
      project_hash = {:label => project.display_name, :value => tests_count}
      projects_array = projects_array.push(project_hash)

      separate_widget_name = "jenkins_#{project.jenkins_name}"
      send_event(separate_widget_name, { current: tests_count })
    end
    projects_array = projects_array.sort_by {|hash| hash[:value]}.reverse!
    puts("Jenkins data: #{projects_array}")
    send_event('jenkins', { items: projects_array })
end