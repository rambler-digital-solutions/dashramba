require 'watir'

module Fabric
  class FabricService

    def fetch_crashfree_for_bundle_id(bundle_id)

        browser = Watir::Browser.new :safari
        browser.goto FABRIC_LOGIN_URL
        sleep(LOAD_DELAY)
        
        if browser.url == FABRIC_LOGIN_URL
            browser.form(:class => "sdk-form").wait_until_present
            browser.text_field(:id, "email").set(FABRIC_EMAIL)
            browser.text_field(:id, "password").set(FABRIC_PASSWORD)
            browser.form(:class, "sdk-form").submit
        end
        
        browser.div(:id, "l_dashboard").wait_until_present
        dashboardURL = FABRIC_DASHBOARD_MAIN_URL + bundle_id + FABRIC_DASHBOARD_FILTER
        browser.goto dashboardURL
        browser.div(:id, "l_dashboard").wait_until_present
        sleep(LOAD_DELAY)
        crashfree = browser.span(:class, "crash-free-percent").div(:class, "stat mini ").divs.first.span.text
        if crashfree != "..."
            crashfree_value = crashfree.chomp("%")
            response = Hash.new
            response["crashfree"] = crashfree_value
            mapper = Fabric::FabricMapper.new
            model = mapper.map_response(response, bundle_id)
            model.save() if model != nil
        end

        browser.close

    end

    def obtain_crashfree_for_bundle_id(bundle_id)
       Fabric::FabricModel.first(:bundle_id => bundle_id)
    end
    
  end
end