require_relative 'config_constants'

module Infrastructure
  class ProjectModel
    attr_reader :project_name,
                :display_name,
                :appstore_id,
                :bundle_id

    def initialize(name, hash)
      @project_name = name
      @display_name = hash[DISPLAY_NAME_KEY]
      @appstore_id = hash[APPSTORE_ID_KEY]
      @bundle_id = hash[BUNDLE_ID_KEY]
    end
  end
end