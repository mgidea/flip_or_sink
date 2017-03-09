require 'httparty'
module Request
  class Onboard
    include HTTParty
    attr_reader :response

    def default_headers
      {"Content-Type"=>"application/json", "Accept"=>"application/json", "apikey"=>ONBOARD_CONFIG["api_key"]}
    end

    def default_options
      {:headers => default_headers}
    end

    def get(options = {})
      # camelize all query options
      options[:query] = options[:query].inject({}) { |h, q| h[q[0].to_s.camelize] = q[1]; h }
      @response = self.class.get(url, default_options.deep_merge(options))
      self
    end

    def response_items
      return [] unless response && response.code == 200
      (response.parsed_response||{}).dig("response", "result", "package", "item") || []
    end

    def ok?
      response&.ok? || (response && response.code == 200)
    end
  end
end
