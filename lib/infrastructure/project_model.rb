require_relative 'config_constants'

module Infrastructure
  class ProjectModel
    attr_reader :project_id,
                :project_name,
                :display_name,
                :appstore_id,
                :jenkins_name,
                :fabric_project_id,
                :google_code_review_cell_id,
                :enterprise_bundle_id

    def initialize(name, hash)
      @project_name = name
      @project_id = hash[PROJECT_ID_KEY]
      @display_name = hash[DISPLAY_NAME_KEY]
      @appstore_id = hash[APPSTORE_ID_KEY]
      @jenkins_name = hash[JENKINS_NAME_KEY]
      @fabric_project_id = hash[FABRIC_PROJECT_ID_KEY]
      @google_code_review_cell_id = hash[GOOGLE_CODE_REVIEW_CELL_ID]
      @enterprise_bundle_id = hash[ENTERPRISE_BUNDLE_ID]
    end
  end
end