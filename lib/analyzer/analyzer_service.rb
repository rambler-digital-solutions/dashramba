require_relative 'analyzer_mapper'
require_relative 'analyzer_model'

module Analyzer

  class AnalyzerService

    def initialize
      @config = YAML::load_file('analyzer.yml')
    end

    def fetch_analysis_for_bundle_id(bundle_id)
      url = Pathname.new(@config['report_url'])
                .join("#{bundle_id}.json")
      uri = URI(url.to_s)

      response = Net::HTTP.get(uri)
      hash = JSON.parse(response)

      mapper = Analyzer::AnalyzerMapper.new
      model = mapper.map_response(hash, bundle_id)

      model.save() if model != nil
    end

    def obtain_analysis_model_for_bundle_id(bundle_id)
      Analyzer::AnalyzerModel.first(:enterprise_bundle_id => bundle_id)
    end

    def obtain_maximum_first_priority_issue_count(bundle_id)
      Analyzer::AnalyzerModel.max(:number_of_first_priority_issues)
    end

    def obtain_maximum_second_priority_issue_count(bundle_id)
      Analyzer::AnalyzerModel.max(:number_of_second_priority_issues)
    end

    def obtain_maximum_third_priority_issue_count(bundle_id)
      Analyzer::AnalyzerModel.max(:number_of_third_priority_issues)
    end

    def obtain_maximum_warnings_count(bundle_id)
      Analyzer::AnalyzerModel.max(:number_of_xcode_warnings)
    end
  end

end