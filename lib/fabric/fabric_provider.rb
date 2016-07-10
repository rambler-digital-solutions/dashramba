require 'net/http'
require 'openssl'
require 'json'
require 'uri'

module Fabric

  FABRIC_URL = 'https://instant.fabric.io'

  API_OAUTH = '/oauth/'
  API_VERSION_2 = '/api/v2/'
  API_VERSION_3 = '/api/v3/'

  class FabricProvider

    def initialize
      @uri = URI.parse(FABRIC_URL)
      @http = Net::HTTP.new(@uri.host, @uri.port)
      @http.use_ssl = true
      @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    def authorize(email, password, client_id, client_secret)
      request = Net::HTTP::Post.new(API_OAUTH + 'token')
      request.add_field('Content-Type', 'application/json')
      requestData =  {
          'grant_type' => 'password',
          'scope' => 'organizations apps issues features account twitter_client_apps beta software answers',
          'username' => email,
          'password' => password,
          'client_id' => client_id,
          'client_secret' => client_secret
      }
      request.body = requestData.to_json
      response = @http.request(request)
      JSON.parse(response.body)
    end

    def account(token)
      request = Net::HTTP::Get.new(API_VERSION_3 + 'account')
      request['Authorization'] = 'Bearer ' + token
      response = http.request(request)
      JSON.parse(response.body)
    end

    def crash_free_users(token, start_timestamp, end_timestamp, organization_id, project_id)
      organization = 'organizations/' + organization_id
      project = '/apps/' + project_id
      endpoint = '/growth_analytics/crash_free_users_for_top_builds.json'
      start_filter = '?start=' + start_timestamp.to_s
      end_filter = '&end=' + end_timestamp.to_s
      request_uri = API_VERSION_2 + organization + project + endpoint + start_filter + end_filter
      request = Net::HTTP::Get.new(request_uri)
      request['Authorization'] = 'Bearer ' + token
      response = @http.request(request)
      JSON.parse(response.body)
    end

  end

end