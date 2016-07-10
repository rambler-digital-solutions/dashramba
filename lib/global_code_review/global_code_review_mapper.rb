require_relative 'global_code_review_model'

module GlobalCodeReview
  class GlobalCodeReviewMapper

    def map_response(date, cell_id)
      model_hash = {
          :cell_id => cell_id,
          :date => date
      }
      review = GlobalCodeReview::GlobalCodeReviewModel.first(:cell_id => model_hash[:cell_id])
      if review != nil
        review.update(model_hash)
      else
        review = GlobalCodeReview::GlobalCodeReviewModel.new(model_hash)
      end

      review
    end
  end
end