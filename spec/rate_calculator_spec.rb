require 'rspec'
require_relative '../lib/appstore/rate_calculator'
require_relative '../lib/appstore/review_model'
require_relative '../lib/appstore/review_mapper'

describe 'RateCalculator' do
  before(:each) do
    @calculator = AppStore::RateCalculator.new
    @mapper = AppStore::ReviewMapper.new
  end

  it 'should calculate average rate for multiple reviews' do
    ratings = [3, 4, 4, 4, 5]
    expected_average_rate = (ratings.inject(0) { |sum, x| sum+x } / ratings.count).to_f

    reviews = Array.new
    ratings.each do |rating|
      review_hash = {
          'author'=> {
              'name'=> {
                  'label' => 'Roarklina'
              }
          },
          'im:version' => {
            'label' => "3.2.0"
          },
          'im:rating' => {
            'label' => rating.to_s
          },
          'content' => {
            'label' => "Приложение удобное, но с одним минусом. Добавьте, пожалуйста, чтобы на страницах выставок тоже были карты с отметкой где находится место проведения как на страницах других мероприятий."
          },
          'title' => {
              'label' => "Все супер"
          }
      }
      review = @mapper.map_response(review_hash)
      reviews.push(review)
    end

    average_rate = @calculator.calculate_average_rate(reviews)
    expect(average_rate).to equal(expected_average_rate)
  end

  it 'should calculate average rating for the latest version' do
    ratings = [3, 4, 4, 4, 5]
    versions = ['1.0', '1.0', '1.5', '1.5', '1.5']

    expected_average_rate = (ratings[2..4].inject(0) { |sum, x| sum+x }.to_f / ratings[2..4].count).to_f

    reviews = Array.new
    ratings.zip(versions).each do |rating, version|
      review_hash = {
          'author'=> {
              'name'=> {
                  'label' => 'Roarklina'
              }
          },
          'im:version' => {
              'label' => version
          },
          'im:rating' => {
              'label' => rating.to_s
          },
          'content' => {
              'label' => "Приложение удобное, но с одним минусом. Добавьте, пожалуйста, чтобы на страницах выставок тоже были карты с отметкой где находится место проведения как на страницах других мероприятий."
          },
          'title' => {
              'label' => "Все супер"
          }
      }
      review = @mapper.map_response(review_hash)
      reviews.push(review)
    end

    average_rate = @calculator.calculate_latest_version_average_rate(reviews)
    expect(average_rate).to equal(expected_average_rate)
  end
end