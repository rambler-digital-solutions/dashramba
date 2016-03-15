require 'net/http'
require 'json'

module AppStore

	class ReviewModel
		attr_reader :author_name,
								:rating,
								:title,
								:text

		def initialize(hash)
			@author_name = hash['author']['name']['label']
			@rating = hash['im:rating']['label']
			@title = hash['title']['label']
			@text = hash['content']['label']
		end
	end



end

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

  medium_rate = 0.0
  models.each do |review|
    medium_rate = medium_rate + review.rating.to_i
  end

  average_rate = medium_rate / models.count

  	send_event('welcome', { 'title' => average_rate.to_s } )
end