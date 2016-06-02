require_relative 'global_code_review_constants'
require_relative 'global_code_review_mapper'
require_relative 'global_code_review_model'

require_relative '../../lib/google_drive/google_drive_client'

module GlobalCodeReview
  class GlobalCodeReviewService

    def fetch_review_status_for_cell_id(cell_id)
      client = GoogleDrive::GoogleDriveClient.new
      mapper = GlobalCodeReview::GlobalCodeReviewMapper.new

      session = client.obtain_session

      spreadsheet_id = ENV['DASHING_TARGET_SPREAD_SHEET_ID']

      review_date_string = client.obtain_spreadsheet_value(session,
                                                           spreadsheet_id,
                                                           REVIEW_STATE_WORKSHEET_NUMBER,
                                                           cell_id)

      model = mapper.map_response(review_date_string, cell_id)
      if model != nil
        model.save()
      end
    end

    def obtain_review_status_for_cell_id(cell_id)
      GlobalCodeReview::GlobalCodeReviewModel.first(:cell_id => cell_id)
    end
  end
end