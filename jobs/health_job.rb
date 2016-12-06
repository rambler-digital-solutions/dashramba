require_relative '../lib/infrastructure/project_manager'
require_relative '../lib/infrastructure/project_model'
require_relative '../lib/analyzer/analyzer_service'
require_relative '../lib/fabric/fabric_service'
require_relative '../lib/analyzer/analyzer_model'
require_relative '../lib/fabric/fabric_model'

@fabric_service = Fabric::FabricService.new

SCHEDULER.every '1d', :first_in => 0 do |job|
  project_manager = Infrastructure::ProjectManager.new

  analyzer_service = Analyzer::AnalyzerService.new
  array = []

  projects = project_manager.obtain_all_projects.select { |project|
    project.enterprise_bundle_id != nil
  }

  projects.each do |project|
    analyzer_model = analyzer_service.obtain_analysis_model_for_bundle_id(project.enterprise_bundle_id)
    fabric_model = @fabric_service.obtain_fabric_model_for_bundle_id(project.fabric_project_id)

    if analyzer_model != nil && fabric_model != nil
      health = count_health_with_crashfree(analyzer_service, analyzer_model, fabric_model, project.enterprise_bundle_id)
      project_hash = {:label => project.display_name, :value => "#{health}/10"}
      array.push(project_hash)
      puts(project_hash)
      widget_name = "health_#{project.project_id}"
      send_event(widget_name,  { 'rating' => health.round(1) })
    end
  end
  puts(array)
  array = array.sort_by {|hash| hash[:value]}.reverse!
  send_event('health', { items: array })
end

def count_health_with_crashfree(analyzer_service, analyzer_model, fabric_model, bundle_id)
  first_priority = analyzer_model.number_of_first_priority_issues
  maximum_first_priority = analyzer_service.obtain_maximum_first_priority_issue_count(bundle_id)

  second_priority = analyzer_model.number_of_second_priority_issues
  maximum_second_priority = analyzer_service.obtain_maximum_second_priority_issue_count(bundle_id)

  third_priority = analyzer_model.number_of_third_priority_issues
  maximum_third_priority = analyzer_service.obtain_maximum_third_priority_issue_count(bundle_id)

  warnings = analyzer_model.number_of_xcode_warnings
  maximum_warnings = analyzer_service.obtain_maximum_warnings_count(bundle_id)

  crashfree = fabric_model.average_monthly_crashfree * 100
  crashfree_coefficient = 0
  if crashfree > 98
    # В том случае, если crashfree > 98%, высчитываем его по линейной формуле (0,7x - 68,6)/2 + 0,3
    # Т.е. полученный коэффициент находится в промежутке [0,3;1,0]
    crashfree_coefficient = (0.7 * crashfree - 68.6)/2 + 0.3
  else
    # Коэффициент находится в промежутке [0,3;1,0]
    crashfree_coefficient = crashfree * 0.003 / 0.9
  end

  oomfree = fabric_model.average_monthly_oomfree * 100
  oomfree_coefficient = 0
  if oomfree > 96
    # В том случае, если oomfree > 96%, высчитываем его по линейной формуле (0,7x - 67,2)/4 + 0,3
    # Т.е. полученный коэффициент находится в промежутке [0,3;1,0]
    oomfree_coefficient = (0.7 * oomfree - 67.2)/4 + 0.3
  else
    # Коэффициент находится в промежутке [0,3;1,0]
    oomfree_coefficient = oomfree * 0.3 / 96
  end

  overall_weight = 10
  overall_points = 25
  points_level_1 = 7
  points_level_2 = 6
  points_level_3 = 5
  points_level_4 = 4
  points_level_5 = 2
  points_level_6 = 1

  point_weight = overall_weight.to_f / overall_points.to_f
  weights = [points_level_1 * point_weight,
             points_level_2 * point_weight,
             points_level_3 * point_weight,
             points_level_4 * point_weight,
             points_level_5 * point_weight,
             points_level_6 * point_weight]
  data = [crashfree_coefficient,
          count_coefficient(first_priority, maximum_first_priority),
          oomfree_coefficient,
          count_coefficient(second_priority, maximum_second_priority),
          count_coefficient(warnings, maximum_warnings),
          count_coefficient(third_priority, maximum_third_priority)]
  count_health_with_data(data, weights).round(2)
end

def count_health_with_data(data, weights)
  result = 0
  data.zip(weights).each do |value, weight|
    result = result.to_f + value.to_f * weight.to_f
  end
  result
end

def count_coefficient(value, maximum_value)
  if maximum_value == 0
    coefficient = 1
  else
    coefficient = 1 - (value.to_f / maximum_value.to_f)
  end
  coefficient
end