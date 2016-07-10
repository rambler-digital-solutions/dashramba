require_relative 'fabric_model'

module Fabric
  class FabricMapper

    def map_response(response, fabric_project_id)
      model_hash = {
          :crashfree => response['crashfree'],
          :fabric_project_id => fabric_project_id
      }
      model = Fabric::FabricModel.first(:fabric_project_id => fabric_project_id)
      Fabric::FabricModel.new(model_hash) unless model != nil
    end
  end
end