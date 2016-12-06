require 'jenkins_api_client'
require_relative 'jenkins_mapper'
require_relative 'jenkins_model'

module Jenkins
  class JenkinsService
    def initialize
      server_url = ENV.fetch('JENKINS_URL')
      username = ENV.fetch('JENKINS_USERNAME')
      password = ENV.fetch('JENKINS_PASSWORD')
      @client = JenkinsApi::Client.new(:server_url => server_url,
                                       :username => username, :password => password)
      @mapper = Jenkins::JenkinsMapper.new
    end

    def fetch_tests_count(project_name)
      build_number = get_last_successful_build(project_name)
      tests_count = @client.job.get_test_results(project_name, build_number)['passCount']
      model = @mapper.map_tests_data(project_name, tests_count, build_number)
      model.number_of_tests
    end

    private

    def get_last_successful_build(project_name)
      url = "/job/#{project_name}"
      response_json = @client.api_get_request(url)
      response_json['lastSuccessfulBuild']['number']
    end

  end
end