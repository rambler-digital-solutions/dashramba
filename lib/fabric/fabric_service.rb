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
       start_time = time.to_i - 60*60*24*31
       end_time = time.to_i

       json = @provider.crash_free_users(@token,start_time,end_time,@config['fabric_organization_id'], fabric_project_id)

       average_monthly_crashfree = 0
       last_day_crashfree = 0
       builds = json['builds']
       if builds
         all_builds = builds['all'].map do |array|
           array.last
         end
         average_monthly_crashfree = all_builds.inject { |sum, element| sum + element }.to_f / all_builds.size
         last_day_crashfree = all_builds.last
       end       

       if average_monthly_crashfree
       if average_monthly_crashfree != 0 && last_day_crashfree != 0
         mapper = Fabric::FabricMapper.new
         model = mapper.map_response(average_monthly_crashfree, last_day_crashfree, fabric_project_id)
         model.save() if model != nil
       end

    end

    def obtain_crashfree_for_bundle_id(fabric_project_id)
       Fabric::FabricModel.first(:fabric_project_id => fabric_project_id)
    end
    
  end

end