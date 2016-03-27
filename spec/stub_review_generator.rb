require_relative '../lib/appstore/review_model'
require_relative '../lib/appstore/review_mapper'

module AppStoreSpec
  class StubReviewGenerator
    def generate_reviews_with_versions(versions)
      reviews = Array.new
      mapper = AppStore::ReviewMapper.new
      versions.each do |version|
        review_hash = {
            'author'=> {
                'name'=> {
                    'label' => 'etolstoy'
                }
            },
            'im:version' => {
                'label' => version
            },
            'im:rating' => {
                'label' => '5.0'
            },
            'id' => {
                'label' => Random.rand(100000).to_s
            },
            'content' => {
                'label' => 'Приложение удобное'
            },
            'title' => {
                'label' => 'Все супер'
            }
        }
        review = mapper.map_response(review_hash, nil)
        reviews.push(review)
      end
      return reviews
    end

    def generate_reviews_with_ratings(ratings)
      reviews = Array.new
      mapper = AppStore::ReviewMapper.new
      ratings.each do |rating|
        review_hash = {
            'author'=> {
                'name'=> {
                    'label' => 'etolstoy'
                }
            },
            'im:version' => {
                'label' => '3.2.0'
            },
            'im:rating' => {
                'label' => rating
            },
            'id' => {
                'label' => Random.rand(100000).to_s
            },
            'content' => {
                'label' => 'Приложение удобное'
            },
            'title' => {
                'label' => 'Все супер'
            }
        }
        review = mapper.map_response(review_hash, nil)
        reviews.push(review)
      end
      return reviews
    end

    def generate_reviews_with_ratings_and_versions(ratings, versions)
      reviews = Array.new
      mapper = AppStore::ReviewMapper.new
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
            'id' => {
                'label' => Random.rand(100000).to_s
            },
            'content' => {
                'label' => 'Приложение удобное'
            },
            'title' => {
                'label' => 'Все супер'
            }
        }
        review = mapper.map_response(review_hash, nil)
        reviews.push(review)
      end
      return reviews
    end
  end
end