require_relative '../lib/google_drive/google_drive_service'

WORKSHEET_NUMBER = 1 # zero start
CELLS_ROW_NUMBER = 2
CELLS_COLUMN_NUMBER = 3

SCHEDULER.every '10m', :first_in => 0 do |job|
  service = GoogleDrive::GoogleDriveService.new
  access_token = service.obtain_access_token
  spreadsheet_id = ENV['DASHING_TARGET_SPREAD_SHEET_ID']
  review_date = service.obtain_spreadsheet_value(access_token, spreadsheet_id, WORKSHEET_NUMBER, CELLS_ROW_NUMBER, CELLS_COLUMN_NUMBER)
  puts(review_date)
  send_event('google_spreadsheet', { value: review_date  })
end