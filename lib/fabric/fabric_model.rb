require 'data_mapper'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/database.db")

module Fabric
  class FabricModel
    include DataMapper::Resource

    property :id, Serial
    property :fabric_project_id, String
    property :average_monthly_crashfree, Float
    property :last_day_crashfree, Float
    property :active_now, Integer

  end

  DataMapper.finalize
  FabricModel.auto_upgrade!
end