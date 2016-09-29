require_relative '../lib/infrastructure/project_manager'
require_relative '../lib/infrastructure/project_model'
require_relative '../lib/analyzer/analyzer_service'
require_relative '../lib/fabric/fabric_service'
require_relative '../lib/analyzer/analyzer_model'
require_relative '../lib/fabric/fabric_model'

SCHEDULER.every '1d', :first_in => 0 do |job|
  project_manager = Infrastructure::ProjectManager.new

  analyzer_service = Analyzer::AnalyzerService.new
  fabric_service = Fabric::FabricService.new
  project_manager.obtain_all_projects.each do |project|
    next unless project.enterprise_bundle_id != nil

    analyzer_model = service.obtain_analysis_model_for_bundle_id(project.enterprise_bundle_id)
    fabric_model = service.obtain_fabric_model_for_bundle_id(project.fabric_project_id)

    if analyzer_model != nil
      send_top_issues(model, project)
      send_priority_issues(model, project)
      send_warnings(model, project)
      send_number_of_files(model, project)
    end
  end
end

def count_health_with_crashfree(analyzer_model, fabric_model)
  first_priority = analyzer_model.number_of_first_priority_issues
  second_priority = analyzer_model.number_of_second_priority_issues
  third_priority = analyzer_model.number_of_third_priority_issues
  warnings = analyzer_model.number_of_xcode_warnings

  crashfree = model.average_monthly_crashfree

  
end

def count_health_witjout_crashfree

end