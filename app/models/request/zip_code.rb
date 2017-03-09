module Request
  class ZipCode < Usps
    def initialize(*zip_codes)
      @zip_codes = zip_codes
    end

    def api_key
      @api_key ||= 'CityStateLookup'
    end
  end
end
