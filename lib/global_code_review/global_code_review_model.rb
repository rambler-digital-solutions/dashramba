require 'data_mapper'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/database.db")

module GlobalCodeReview
  class GlobalCodeReviewModel
    include DataMapper::Resource

    property :id, Serial
    property :date, Text
    property :cell_id, Text

  end

  DataMapper.finalize
  GlobalCodeReviewModel.auto_upgrade!
end