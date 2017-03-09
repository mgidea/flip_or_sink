module Request
  class County < Base
    attr_accessor :state_code
    def url
      ONBOARD_CONFIG["counties_url"]
    end

    def initialize(state_code)
      @state_code = state_code
    end

    def get(options = {})
      super({:query => {:state_id => state_code}}.deep_merge(options))
    end

    def get_counties
      get
      counties = ok? ? response_items : []
      if block_given?
        yield(state_code, counties)
      else
        counties
      end
    end

    def import_counties
      get_counties do |state_code, counties|
        if (state = State.find_by_code(state_code)) && counties.present?
          ::County.import_state_counties(state, counties)
        end
      end
    end

    def self.get_state_counties(state_codes, &block)
      state_codes.map do |state_code|
        new(state_code).get_counties(&block)
      end
    end

    def self.import_state_counties(state_codes)
      state_codes.map do |state_code|
        new(state_code).import_counties
      end
    end
  end
end
