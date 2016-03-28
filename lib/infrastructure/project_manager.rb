require_relative 'config_constants'
require_relative 'project_model'

module Infrastructure
  class ProjectManager

    def obtain_all_projects
      config = YAML::load_file('config.yml')
      projects = Array.new
      config[PROJECTS_KEY].each do |project_name, options|
        project = Infrastructure::ProjectModel.new(project_name, options)
        projects.push(project)
      end
      return projects
    end
  end
end