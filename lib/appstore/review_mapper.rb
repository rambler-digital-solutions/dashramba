require_relative 'review_model'

module AppStore
  class ReviewMapper

    def map_response(response)
      model_hash = {
          :author_name => response['author']['name']['label'],
          :rating => response['im:rating']['label'],
          :title => response['title']['label'],
          :text => response['content']['label'],
          :version => response['im:version']['label']
      }
      AppStore::ReviewModel.new(model_hash)
    end
  end
end