require_relative 'appstore_constants'
require_relative 'review_model'
require_relative 'review_mapper'

module AppStore
  class ReviewFetcher

    def fetch_reviews_for_app_id(app_id)
      url = Pathname.new(CUSTOMER_REVIEWS_LINK)
                .join(APP_ID_KEY + '=' + app_id)
                .join(SORT_BY_KEY + '=' + MOST_RECENT_SORT_TYPE)
                .join(JSON_OUTPUT_TYPE)
      uri = URI(url.to_s)

      response = Net::HTTP.get(uri)
      hash = JSON.parse(response)
      entries = hash['feed']['entry']

      mapper = AppStore::ReviewMapper.new
      entries = entries.drop(1)
      models = Array.new
      entries.each do |hash|
        model = mapper.map_response(hash)
        model.save()
        models.push(model)
      end
      return models
    end
  end
end