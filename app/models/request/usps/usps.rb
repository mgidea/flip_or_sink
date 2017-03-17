require 'httparty'
module Request
  module Usps
    class Usps
      include HTTParty
      attr_reader :response

      def default_options
        {
          :query => {
            "API" => @api_key,
            "XML" => build_xml
          }
        }
      end

      def get(options = {})
        @response = self.class.get(url, default_options.deep_merge(options))
        self
      end

      def ok?
        response&.ok? || (response && response.code == 200)
      end

      def build(&block)
        builder = Builder::XmlMarkup.new(:indent => 0)
        builder.tag!(api_type, "USERID" => USPS_CONFIG["username"], &block)
      end
    end
  end
end
