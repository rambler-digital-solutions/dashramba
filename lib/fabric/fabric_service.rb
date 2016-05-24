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
       start_time = time.to_i - 60*60*24
       end_time = time.to_i
       json = @provider.crash_free_users(@token,start_time,end_time,@config['fabric_organization_id'], fabric_project_id)

       crashfree = 0
       builds = json['builds']
       if builds
         all_builds = builds['all']
         crashfree = json['builds']['all'].last.last
       end       

       if crashfree
         response = Hash.new
         response["crashfree"] = crashfree
         mapper = Fabric::FabricMapper.new
         model = mapper.map_response(response, fabric_project_id)
         model.save() if model != nil
       end

    end

    def obtain_crashfree_for_bundle_id(fabric_project_id)
       Fabric::FabricModel.first(:fabric_project_id => fabric_project_id)
    end
    
  end

end