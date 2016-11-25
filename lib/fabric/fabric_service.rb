require_relative '../fabric/fabric_provider'
require_relative '../fabric/fabric_model'

module Fabric

  class FabricService

    def initialize
      @provider = Fabric::FabricProvider.new()
      @config = YAML::load_file('fabric.yml')
      @token = @provider.authorize(@config['fabric_email'],
                                   @config['fabric_password'],
                                   @config['fabric_client_id'],
                                   @config['fabric_client_secret'])['access_token']
    end

    def fetch_crashfree_for_bundle_id(fabric_project_id)
       time = Date.today.to_time

       # Obtaining crash-free for the last 31 days
       month_start_time = time.to_i - 60*60*24*31
       day_start_time = time.to_i - 60*60*24
       end_time = time.to_i
       monthly_crashfree = crashfree_for_range(month_start_time, end_time, fabric_project_id)
       day_crashfree = crashfree_for_range(day_start_time, end_time, fabric_project_id)
       if monthly_crashfree != 0
         mapper = Fabric::FabricMapper.new
         model = mapper.map_crashfree_response(monthly_crashfree, day_crashfree, fabric_project_id)
         model.save() if model != nil
       end

    end

    def fetch_oomfree_for_bundle_id(fabric_project_id)
      monthly_oomfree = @provider.oom_free(@token, 31, fabric_project_id)
      daily_oomfree = @provider.oom_free(@token, 1, fabric_project_id)
      if monthly_oomfree != 0 && daily_oomfree != 0
        mapper = Fabric::FabricMapper.new
        model = mapper.map_oom_response(monthly_oomfree, daily_oomfree, fabric_project_id)
        model.save() if model != nil
      end

    end

    def obtain_fabric_model_for_bundle_id(fabric_project_id)
       Fabric::FabricModel.first(:fabric_project_id => fabric_project_id)
    end

    def fetch_active_now_for_bundle_id(fabric_project_id)
      json = @provider.active_now_users(@token, @config['fabric_organization_id'], fabric_project_id)
      active_now = json['cardinality']
      model = Fabric::FabricModel.first(:fabric_project_id => fabric_project_id)
      if model != nil
        model.active_now = active_now
        model.save()
      end

      active_now
    end

    private

    def crashfree_for_range(start_time, end_time, fabric_project_id)
      sessions_count = @provider.sessions_count(@token,start_time,end_time,@config['fabric_organization_id'], fabric_project_id)
      crashes_count = @provider.crashes_count(@token,start_time,end_time,@config['fabric_organization_id'], fabric_project_id)
      1 - crashes_count.to_f/sessions_count.to_f
    end

  end

end