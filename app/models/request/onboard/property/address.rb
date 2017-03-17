module Request
  module Onboard
    module Property
      class Address < Base
        def self.setup_properties(postal_code)
          total = get_total(postal_code)
          queries = 0
          if total && total > 0
            queries = total / 150
            queries += 1 if (total % 150) != 0
          end

          if queries > 0
            (1..queries).map do |num|
              new("postalcode" => postal_code, "page" => num)
            end
          else
            []
          end
        end

        def self.get_properties(postal_code)
          setup_properties(postal_code).map(&:get)
        end

        def self.get_total(postal_code)
          property = new("postalcode" => postal_code, "pagesize" => 1).get
          property.total
        end

        def initialize(options = {})
          @action = "address"
          options.transform_keys{|key| key.to_s.camelize.downcase}
          options.assert_valid_keys("postalcode", "page", "pagesize", "propertytype", "orderby")
          raise "must have postal code" unless options["postalcode"]
          options["page"] ||= 1
          options["pagesize"] ||= 150
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
# to get the sample data
# records = []; filename = "./lib/static_data/sudbury_properties.rb"; File.foreach(filename){|line| records << JSON.parse(line.gsub("=>",":")) }
