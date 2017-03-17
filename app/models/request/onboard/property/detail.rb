module Request
  module Onboard
    module Property
      class Detail < Base
        def initialize(options = {})
          @action = "detail"
          options.transform_keys{|key| key.to_s.camelize.downcase}
          options.assert_valid_keys("address1", "address2")
          raise "must have postal code" unless options["address1"]
          @property_options = options
        end

        def default_headers
          {"Accept"=>"application/json", "apikey"=>ONBOARD_CONFIG["api_key"]}
        end

        def response_items
          parsed_response["property"] || []
        end

        def total
          parsed_response.dig("status", "total").to_i
        end

        def current_page
          parsed_response.dig("status", "page")
        end

        def current_page_size
          parsed_response.dig("status", "pagesize")
        end
      end
    end
  end
end
