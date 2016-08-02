require_relative 'fabric_model'

module Fabric
  class FabricMapper

    def map_response(average_monthly_crashfree, last_day_crashfree, fabric_project_id)
      model_hash = {
          :average_monthly_crashfree => average_monthly_crashfree,
          :last_day_crashfree => last_day_crashfree,
          :fabric_project_id => fabric_project_id
      }
      model = Fabric::FabricModel.first(:fabric_project_id => fabric_project_id)
      if model != nil
        model.update(model_hash)
      else
        model = Fabric::FabricModel.new(model_hash)
      end
      return model
    end
  end
end