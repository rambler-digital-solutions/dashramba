require_relative 'review_model'

module AppStore
  class ReviewMapper

    def map_response(response, app_id)
      model_hash = {
          :id => response['id']['label'],
          :author_name => response['author']['name']['label'],
          :rating => response['im:rating']['label'],
          :title => response['title']['label'],
          :text => response['content']['label'],
          :version => response['im:version']['label'],
          :app_id => app_id
      }
      review = AppStore::ReviewModel.first(:id => model_hash[:id])
      AppStore::ReviewModel.new(model_hash) unless review != nil
    end
  end
end