require 'rspec'
require 'webmock/rspec'

require_relative '../lib/analyzer/analyzer_service'
require_relative '../lib/analyzer/analyzer_model'

describe 'AnalyzerService' do
  before(:each) do
    @service = Analyzer::AnalyzerService.new
  end

  it 'should obtain analysis' do
    response_file = File.new(Dir.getwd + '/spec/analyzer_service_stub_response.txt')
    stub_request(:any, /.*nightly*/).to_return(:body => response_file, :status => 200)

    bundle_id = 'test'
    @service.fetch_analysis_for_bundle_id(bundle_id)
    result = @service.obtain_analysis_model_for_bundle_id(bundle_id)
    expect(result.enterprise_bundle_id).to eq(bundle_id)
  end
end