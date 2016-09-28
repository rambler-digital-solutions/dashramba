require_relative '../lib/infrastructure/project_manager'
require_relative '../lib/infrastructure/project_model'
require_relative '../lib/analyzer/analyzer_service'
require_relative '../lib/analyzer/analyzer_model'

SCHEDULER.every '1d', :first_in => 0 do |job|
  project_manager = Infrastructure::ProjectManager.new

  service = Analyzer::AnalyzerService.new
  project_manager.obtain_all_projects.each do |project|
    next unless project.enterprise_bundle_id != nil

    service.fetch_analysis_for_bundle_id(project.enterprise_bundle_id)
    model = service.obtain_analysis_model_for_bundle_id(project.enterprise_bundle_id)
    if model != nil
      send_top_issues(model, project)
      send_priority_issues(model, project)
      send_warnings(model, project)
    end
  end
end

def send_warnings(model, project)
  widget_name = "warnings_#{project.jenkins_name}"
  send_event(widget_name,  { current: model.number_of_xcode_warnings })
end

def send_priority_issues(model, project)
  widget_name = "analyzer_priority_#{project.jenkins_name}"

  items = [
      {
          :label => 'Критичный',
          :value => model.number_of_first_priority_issues
      },
      {
          :label => 'Средний',
          :value => model.number_of_second_priority_issues
      },
      {
          :label => 'Низкий',
          :value => model.number_of_third_priority_issues
      }
  ]

  send_event(widget_name,  { items: items })
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
  send_event(widget_name, { items: top_issues })
end