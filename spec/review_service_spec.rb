require 'rspec'
require 'webmock/rspec'

require_relative '../lib/appstore/appstore_constants'
require_relative '../lib/appstore/review_service'

describe 'ReviewFetcher' do
  before(:each) do
    @service = AppStore::ReviewService.new
  end

  it 'should fetch reviews' do
    response_file = File.new(Dir.getwd + '/spec/review_fetcher_stub_response.txt')
    stub_request(:any, /.*itunes.apple.com*/).to_return(:body => response_file, :status => 200)
    @service.fetch_reviews_for_app_id('123')

    result_count = AppStore::ReviewModel.all().count
    expect(result_count).to equal(50)
  end

  after(:each) do
    AppStore::ReviewModel.all.destroy
  end
end