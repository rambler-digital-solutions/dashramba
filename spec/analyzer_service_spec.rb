require 'rspec'
require 'webmock/rspec'

require_relative '../lib/analyzer/analyzer_service'

describe 'AnalyzerService' do
  before(:each) do
    @service = Analyzer::AnalyzerService.new
  end

  it 'should fetch json' do
    response_file = File.new(Dir.getwd + '/spec/analyzer_service_stub_response.txt')
    stub_request(:any, /.*nightly*/).to_return(:body => response_file, :status => 200)

    @service.fetch_analysis_for_project('1')


  end
end