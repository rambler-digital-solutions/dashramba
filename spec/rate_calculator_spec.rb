require 'rspec'
require_relative '../lib/appstore/rate_calculator'
require_relative 'stub_review_generator'

describe 'RateCalculator' do
  before(:each) do
    @calculator = AppStore::RateCalculator.new
    @review_generator = AppStoreSpec::StubReviewGenerator.new
  end

  it 'should calculate average rate for multiple reviews' do
    ratings = [3, 4, 4, 4, 5]
    expected_average_rate = (ratings.inject(0) { |sum, x| sum+x } / ratings.count).to_f

    reviews = @review_generator.generate_reviews_with_ratings(ratings)

    average_rate = @calculator.calculate_average_rate(reviews)
    expect(average_rate).to equal(expected_average_rate)
  end

  it 'should calculate average rating for version' do
    ratings = [3, 4, 4, 4, 5]
    versions = ['1.0', '1.0', '1.5', '1.5', '1.5']

    expected_average_rate = (ratings[2..4].inject(0) { |sum, x| sum+x }.to_f / ratings[2..4].count).to_f

    reviews = @review_generator.generate_reviews_with_ratings_and_versions(ratings, versions)

    average_rate = @calculator.calculate_average_rate_for_version(reviews, '1.5')
    expect(average_rate).to equal(expected_average_rate)
  end

end