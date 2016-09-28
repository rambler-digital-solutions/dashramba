require 'data_mapper'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/database.db")

module Analyzer
  class AnalyzerModel
    include DataMapper::Resource

    property :id, Serial
    property :enterprise_bundle_id, String
    property :number_of_files, Integer
    property :number_of_rotten_files, Integer
    property :number_of_first_priority_issues, Integer
    property :number_of_second_priority_issues, Integer
    property :number_of_third_priority_issues, Integer
    property :number_of_xcode_warnings, Integer
    property :top_issues, Object
  end
end