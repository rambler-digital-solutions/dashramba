require_relative 'review_model'

module AppStore
  class VersionDeterminator
    def determine_latest_version(reviews)
      versions = Array.new
      reviews.each do |review|
        version = review.version
        if versions.include?(version) == false
          versions.push(version)
        end
      end

      maximum_version = '0'
      versions.each do |version|
        maximum_version = version unless maximum_version.to_f > version.to_f
      end
      return maximum_version
    end
  end
end