require 'rspec'

require_relative '../lib/appstore/version_determinator'
require_relative 'stub_review_generator'

describe 'VersionDeterminator' do
  before(:each) do
    @determinator = AppStore::VersionDeterminator.new
    @review_generator = AppStoreSpec::StubReviewGenerator.new
  end

  it 'should determine the latest version' do
    versions = ['1.0', '1.0', '1.7', '1.5', '1.5']
    reviews = @review_generator.generate_reviews_with_versions(versions)

    latest_version = @determinator.determine_latest_version(reviews)
    expect(latest_version).to eq('1.7')
  end
end