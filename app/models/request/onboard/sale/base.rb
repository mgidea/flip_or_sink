module Request
  module Onboard
    module Sale
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
          @url || ONBOARD_CONFIG["sale_url"] + action
        end
      end
    end
  end
end
