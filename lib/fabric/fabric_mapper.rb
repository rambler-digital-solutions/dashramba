require_relative 'fabric_model'

module Fabric
  class FabricMapper

    def map_response(response, bundle_id)
      model_hash = {
          :crashfree => response['crashfree'],
          :bundle_id => bundle_id
      }
      model = Fabric::FabricModel.first(:bundle_id => bundle_id)
      Fabric::FabricModel.new(model_hash) unless model != nil
    end
  end
end