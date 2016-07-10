require 'data_mapper'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/database.db")

module Fabric
  class FabricModel
    include DataMapper::Resource

    property :id, Serial
    property :fabric_project_id, String
    property :crashfree, Float

  end

  DataMapper.finalize
  FabricModel.auto_upgrade!
end