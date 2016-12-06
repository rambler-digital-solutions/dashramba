require_relative 'jenkins_model'

module Jenkins
  class JenkinsMapper
    def map_tests_data(jenkins_project_name, number_of_tests, build_number)
      model_hash = {
          :jenkins_project_name => jenkins_project_name,
          :number_of_tests => number_of_tests,
          :build_number => build_number
      }
      model = Jenkins::JenkinsModel.first(:jenkins_project_name => jenkins_project_name,
                                          :build_number => build_number)
      if model != nil
        model.update(model_hash)
      else
        model = Jenkins::JenkinsModel.new(model_hash)
      end
      return model
    end
  end
end