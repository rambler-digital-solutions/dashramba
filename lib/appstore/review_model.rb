require 'data_mapper'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/database.db")

module AppStore
  class ReviewModel
    include DataMapper::Resource

    property :id, Serial
    property :app_id, String
    property :author_name, String
    property :rating, String
    property :title, String
    property :text, Text
    property :version, String

  end

  DataMapper.finalize
  ReviewModel.auto_upgrade!
end