require 'httparty'
module Request
  module Onboard
    class Base
      include HTTParty
      debug_output $stdout
      attr_reader :response

      def default_headers
        {"Content-Type"=>"application/json", "Accept"=>"application/json", "apikey"=>ONBOARD_CONFIG["api_key"]}
      end

      def default_options
        {:headers => default_headers}
      end

      def get(options = {})
        @response = self.class.get(url, default_options.deep_merge(options))
        self
      end

      def response_items
        parsed_response.dig("response", "result", "package", "item") || []
      end

      def parsed_response
        return {} unless ok?
        (response.parsed_response||{})
      end

      def ok?
        response&.ok? || (response && response.code == 200)
      end
    end
  end
end
