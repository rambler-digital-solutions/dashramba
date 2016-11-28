require 'dotenv'
Dotenv.load
require 'sinatra/cyclist'
require 'dashing'

configure do
  set :auth_token, 'YOUR_AUTH_TOKEN'

  helpers do
    def protected!
     # Put any authentication code you want in here.
     # This method is run before accessing any resource.
    end
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

set :routes_to_cycle_through, [:afisha, :afisha_tech, :afisha_restaurants, :afisha_restaurants_tech, :afisha_eda, :afisha_eda_tech, :livejournal, :livejournal_tech, :championat, :championat_tech, :kassa, :kassa_tech, :lenta, :lenta_tech, :scanner_tech, :instamedia_tech, :mail, :news, :tests_leaderboard, :crashfree_leaderboard, :active_now_leaderboard, :health_leaderboard, :oomfree_leaderboard]

run Sinatra::Application