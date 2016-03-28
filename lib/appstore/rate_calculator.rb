require_relative 'review_model'

module AppStore
  class RateCalculator

    def calculate_average_rate(reviews)
      medium_rate = 0.0
      reviews.each do |review|
        medium_rate = medium_rate + review.rating.to_i
      end

      medium_rate / reviews.count
    end

    def calculate_average_rate_for_version(reviews, version)
      current_version_reviews = Array.new
      reviews.each do |review|
        review_version = review.version
        if review_version == version
          current_version_reviews.push(review)
        end
      end
      calculate_average_rate(current_version_reviews)
    end

  end
end