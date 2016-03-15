require 'net/http'
require 'json'

SCHEDULER.every '1m', :first_in => 0 do |job|

	url = "http://itunes.apple.com/ru/rss/customerreviews/id=323214038/sortBy=mostRecent/json"
	uri = URI(url)

	response = Net::HTTP.get(uri)
	hash = JSON.parse(response)
	author = hash['feed']['author']['name']['label']

  	send_event('welcome', { 'title' => author } )
end