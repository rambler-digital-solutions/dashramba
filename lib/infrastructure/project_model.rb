require_relative 'config_constants'

module Infrastructure
  class ProjectModel
    attr_reader :project_name,
                :display_name,
                :appstore_id,
                :jenkins_name,
                :bundle_id,
                :fabric_project_id

    def initialize(name, hash)
      @project_name = name
      @display_name = hash[DISPLAY_NAME_KEY]
      @appstore_id = hash[APPSTORE_ID_KEY]
      @jenkins_name = hash[JENKINS_NAME_KEY]
      @bundle_id = hash[BUNDLE_ID_KEY]
      @fabric_project_id = hash[FABRIC_PROJECT_ID_KEY]
    end
  end
end