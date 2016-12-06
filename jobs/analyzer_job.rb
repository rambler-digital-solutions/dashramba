require_relative '../lib/infrastructure/project_manager'
require_relative '../lib/infrastructure/project_model'
require_relative '../lib/analyzer/analyzer_service'
require_relative '../lib/analyzer/analyzer_model'

# SCHEDULER.cron '0 8 * * *' do |job|
SCHEDULER.every '15m', :first_in => 0 do |job|
  project_manager = Infrastructure::ProjectManager.new
  service = Analyzer::AnalyzerService.new
  projects = project_manager.obtain_all_projects.select { |project|
    project.enterprise_bundle_id != nil
  }
  projects.each do |project|
    service.fetch_analysis_for_bundle_id(project.enterprise_bundle_id)
    model = service.obtain_analysis_model_for_bundle_id(project.enterprise_bundle_id)
    if model != nil
      send_top_issues(model, project)
      send_priority_issues(model, project)
      send_warnings(model, project)
      send_number_of_files(model, project)
    end
  end
end

def send_number_of_files(model, project)
  widget_name = "file_number_#{project.jenkins_name}"
  send_event(widget_name,  { current: model.number_of_files })
end

def send_warnings(model, project)
  widget_name = "warnings_#{project.jenkins_name}"
  send_event(widget_name,  { current: model.number_of_xcode_warnings })
end

def send_priority_issues(model, project)
  widget_name = "analyzer_priority_#{project.jenkins_name}"
  send_event(widget_name,  {
                            'priority1' => model.number_of_first_priority_issues,
                            'priority2' => model.number_of_second_priority_issues,
                            'priority3' => model.number_of_third_priority_issues
                        })
end

def send_top_issues(model, project)
  top_issues = []
  model.top_issues.each { |issue|
    issue_hash = {
        :label => issue[0],
        :value => issue[1]
    }
    top_issues.push(issue_hash)
  }

  widget_name = "analyzer_top_#{project.jenkins_name}"
  send_event(widget_name, {
                            items: top_issues[0..9],
                            title: "#{project.display_name}: Top Issues"
                        })
end