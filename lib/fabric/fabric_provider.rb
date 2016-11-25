require 'net/http'
require 'openssl'
require 'json'
require 'uri'
require 'json/ext'

module Fabric

  FABRIC_URL = 'https://instant.fabric.io'
  FABRIC_GRAPHQL_URL = 'https://api-dash.fabric.io/graphql'

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

    def active_now_users(token, organization_id, project_id)
      organization = 'organizations/' + organization_id
      project = '/apps/' + project_id
      endpoint = '/growth_analytics/active_now.json'
      request_uri = API_VERSION_2 + organization + project + endpoint
      request = Net::HTTP::Get.new(request_uri)
      request['Authorization'] = 'Bearer ' + token
      response = @http.request(request)
      JSON.parse(response.body)
    end

    def sessions_count(token, start_timestamp, end_timestamp, organization_id, project_id)
      organization = 'organizations/' + organization_id
      project = '/apps/' + project_id
      endpoint = '/growth_analytics/total_sessions_scalar'
      start_filter = '?start=' + start_timestamp.to_s
      end_filter = '&end=' + end_timestamp.to_s
      request_uri = API_VERSION_2 + organization + project + endpoint + start_filter + end_filter
      request = Net::HTTP::Get.new(request_uri)
      request['Authorization'] = 'Bearer ' + token
      response = @http.request(request)
      parsed_response = JSON.parse(response.body)
      parsed_response['sessions']
    end

    def crashes_count(token, start_timestamp, end_timestamp, organization_id, project_id)
      uri = URI.parse(FABRIC_GRAPHQL_URL)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Post.new(uri)
      request.content_type = 'application/json'
      request.add_field('Authorization', 'Bearer ' + token)
      request.body = {
          'query' => "query AppScalars($externalId_0:String!,$type_1:IssueType!,$filters_2:IssueFiltersType!) {project(externalId:$externalId_0) {crashlytics {scalars:scalars(type:$type_1,start:#{start_timestamp.to_s},end:#{end_timestamp.to_s},filters:$filters_2) {crashes,issues,impactedDevices}},id}}",
          'variables' => {'externalId_0' => project_id,
                          'type_1' => 'crash',
                          'filters_2' => {
                              'cohort' => nil
                          }
          }
      }.to_json
      response = http.request(request)
      parsed_response = JSON.parse(response.body)
      parsed_response['data']['project']['crashlytics']['scalars']['crashes']
    end

    def oom_free(token, days, project_id)
      uri = URI.parse(FABRIC_GRAPHQL_URL)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Post.new(uri)
      request.content_type = 'application/json'
      request.add_field('Authorization', 'Bearer ' + token)
      request.body = {
          'query' => "query oomCountForDaysForBuild($projectId: String!, $builds: [String!]!, $days: Int!) { project(externalId: $projectId) { crashlytics{ oomCounts(builds: $builds, days: $days){ timeSeries{ allTimeCount } } oomSessionCounts(builds: $builds, days: $days){ timeSeries{ allTimeCount } } } } }",
          'variables' => {'projectId' => project_id,
                          'days' => days,
                          'builds' => [
                              'all'
                          ]
          }
      }.to_json
      response = http.request(request)
      parsed_response = JSON.parse(response.body)
      oom_count = parsed_response['data']['project']['crashlytics']['oomCounts']['timeSeries'][0]['allTimeCount']
      oom_session_count = parsed_response['data']['project']['crashlytics']['oomSessionCounts']['timeSeries'][0]['allTimeCount']
      1 - oom_count.to_f/oom_session_count.to_f
    end

  end

end