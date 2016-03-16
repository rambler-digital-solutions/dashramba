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