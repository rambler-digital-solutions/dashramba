
require_relative 'analyzer_mapper'
module Analyzer

  class AnalyzerService

    def initialize
      @config = YAML::load_file('analyzer.yml')
    end

    def fetch_analysis_for_project(bundle_id)
      url = Pathname.new(@config['report_url'])
                .join(bundle_id)
                .join('json')
      uri = URI(url.to_s)

      response = Net::HTTP.get(uri)
      hash = JSON.parse(response)

      mapper = Analyzer::AnalyzerMapper.new
      mapper.map_response(hash, bundle_id)

    end
  end

end