module Request
  module Onboard
    module Property
      class Base < Request::Onboard::Base
        attr_accessor :action, :property_options

        def initialize(options = {})
          @property_options = options
        end

        def default_headers
          {"Accept"=>"application/json", "apikey"=>ONBOARD_CONFIG["api_key"]}
        end

        def get(options = {})
          super({:query => @property_options}.deep_merge(options))
        end

        def url
          @url || ONBOARD_CONFIG["property_url"] + action
        end

        def base_url
          @base_url ||= ONBOARD_CONFIG["property_url"]
        end
      end
    end
  end
end
