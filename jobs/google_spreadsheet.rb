require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/file_storage'
require 'google/api_client/auth/installed_app'
require 'google_drive'

WORKSHEET_NUMBER = 1 # zero start
CELLS_ROW_NUMBER = 1
CELLS_COLUMN_NUMBER = 1

def authorize
  client = Google::APIClient.new(
    :application_name => 'Get Value from Google SpreadSheet for Dashing',
    :application_version => '1.0.0')

  file_storage = Google::APIClient::FileStorage.new('credential-oauth2.json')
  if file_storage.authorization.nil?
    flow = Google::APIClient::InstalledAppFlow.new(
      :client_id => ENV['GOOGLE_DRIVE_CLIENT_ID'],
      :client_secret => ENV['GOOGLE_DRIVE_CLIENT_SECRET'],
      :scope => %w(
        https://www.googleapis.com/auth/drive
        https://docs.google.com/feeds/
        https://docs.googleusercontent.com/
        https://spreadsheets.google.com/feeds/
      ),
    )
    client.authorization = flow.authorize(file_storage)
  else
    client.authorization = file_storage.authorization
  end

  client
end

SCHEDULER.every '10m', :first_in => 0 do |job|
  client = authorize
  session = GoogleDrive.login_with_oauth(client.authorization.access_token)
  ws = session.spreadsheet_by_key(ENV['DASHING_TARGET_SPREAD_SHEET_ID']).worksheets[WORKSHEET_NUMBER]

  cell_value = ws[CELLS_ROW_NUMBER, CELLS_COLUMN_NUMBER]
  send_event('google_spreadsheet', { value: cell_value  })
end