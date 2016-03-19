require 'net/http'
require 'json'

require_relative '../lib/appstore/rate_calculator'
require_relative '../lib/appstore/review_fetcher'

SCHEDULER.every '1m', :first_in => 0 do |job|
	fetcher = AppStore::ReviewFetcher.new
  reviews = fetcher.fetch_reviews_for_app_id('323214038')

  rate_calculator = AppStore::RateCalculator.new
  rating = rate_calculator.calculate_latest_version_average_rate(reviews)
	send_event('welcome', { 'title' => rating.round(2).to_s } )
end