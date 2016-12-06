require 'jenkins_api_client'

module Jenkins
  class JenkinsService
    def initialize
      server_url = ENV.fetch('JENKINS_URL')
      username = ENV.fetch('JENKINS_USERNAME')
      password = ENV.fetch('JENKINS_PASSWORD')
      @client = JenkinsApi::Client.new(:server_url => server_url,
                                       :username => username, :password => password)
    end

    def fetch_tests_count(project_name)
      build_number = get_last_successful_build(project_name)
      puts(@client.job.get_test_results(project_name, build_number)['passCount'])
    end

    private

    def get_last_successful_build(project_name)
      url = "/job/#{project_name}"
      response_json = @client.api_get_request(url)
      response_json['lastSuccessfulBuild']['number']
    end

  end
end