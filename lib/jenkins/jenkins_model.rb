require 'data_mapper'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/database.db")

module Jenkins
  class JenkinsModel
    include DataMapper::Resource

    property :id, Serial
    property :jenkins_project_name, String
    property :number_of_tests, Integer
    property :build_number, Integer

  end

  DataMapper.finalize
  JenkinsModel.auto_upgrade!
end