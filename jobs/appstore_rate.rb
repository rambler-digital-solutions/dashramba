require 'net/http'
require 'json'

require_relative '../lib/appstore/rate_calculator'
require_relative '../lib/appstore/review_service'

SCHEDULER.every '1m', :first_in => 0 do |job|
	service = AppStore::ReviewService.new
  service.fetch_reviews_for_app_id('323214038')

  rate_calculator = AppStore::RateCalculator.new
  reviews = service.obtain_reviews_for_app_id('323214038')
  rating = rate_calculator.calculate_latest_version_average_rate(reviews)
	send_event('welcome', { 'title' => rating.round(2).to_s } )
end