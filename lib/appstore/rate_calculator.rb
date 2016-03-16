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

    def calculate_latest_version_average_rate(reviews)
      version_reviews_hash = Hash.new

      reviews.each do |review|
        version = review.version
        if version_reviews_hash.key? version
          current_version_reviews = version_reviews_hash[version]
          current_version_reviews.push(review)
        else
          current_version_reviews = Array.new
          current_version_reviews.push(review)
          version_reviews_hash[version] = current_version_reviews
        end
      end

      maximum_version = '0'
      version_reviews_hash.keys.each do |version|
        maximum_version = version unless maximum_version.to_f > version.to_f
      end

      latest_version_reviews = version_reviews_hash[maximum_version.to_s]
      calculate_average_rate(latest_version_reviews)
    end

  end
end