require 'net/http'
require 'json'

require_relative '../lib/appstore/review_model'
require_relative '../lib/appstore/rate_calculator'

SCHEDULER.every '1m', :first_in => 0 do |job|

	url = "http://itunes.apple.com/ru/rss/customerreviews/id=323214038/sortBy=mostRecent/json"
	uri = URI(url)

	response = Net::HTTP.get(uri)
	hash = JSON.parse(response)
	entries = hash['feed']['entry']

	entries = entries.drop(1)
  models = Array.new
	entries.each do |mhash|
    puts(mhash)
    model = AppStore::ReviewModel.new(mhash)
    models.push(model)
  end

  rate_calculator = AppStore::RateCalculator.new
  rating = rate_calculator.calculate_latest_version_average_rate(models)


	send_event('welcome', { 'title' => rating.round(2).to_s } )
end