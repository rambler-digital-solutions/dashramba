source 'https://rubygems.org'

gem 'rake'
gem 'dotenv'
gem 'dashing'
gem 'dm-sqlite-adapter'
gem 'data_mapper'
gem 'sinatra_cyclist'
gem 'google-api-client', '<0.9'
gem 'google_drive'
gem 'jenkins_api_client'

# ActiveSupport dependency is not used by dashramba; instead google-api-client
# 0.8.6 requires it. We lock it to 4.2.7 so as to avoid using 5.0, which is
# not compatible with older versions of Ruby. Once google-api-client is
# upgraded to 0.9 this should be removed.
gem 'activesupport', "~> 4.2.7"

gem 'rspec'
gem 'rspec-core'
gem 'webmock'