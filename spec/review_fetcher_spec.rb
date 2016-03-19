require 'rspec'
require 'webmock/rspec'

require_relative '../lib/appstore/appstore_constants'
require_relative '../lib/appstore/review_fetcher'

describe 'ReviewFetcher' do

  it 'should fetch reviews' do
    response_file = File.new(Dir.getwd + '/spec/review_fetcher_stub_response.txt')
    stub_request(:any, /.*#{AppStore::CUSTOMER_REVIEWS_LINK}*/).to_return(:body => response_file, :status => 200)

    fetcher = AppStore::ReviewFetcher.new
    reviews = fetcher.fetch_reviews_for_app_id('123')

    expect(reviews.count).to equal(50)
  end
end