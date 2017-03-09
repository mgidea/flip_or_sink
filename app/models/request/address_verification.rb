module Request
  class AddressVerification < Usps

    ADDRESS_KEY_DECODER = {
      "address" => "Address2",
      "address2" => "Address1",
      "city" => "City",
      "state" => "State"
    }

    DECODED_ADDRESS_KEYS = ADDRESS_KEY_DECODER.keys + ["zip"]

    attr_reader :addresses

    def initialize(*addresses)
      @addresses = addresses
      @response = {}
    end

    def self.verify_address(*addresses)
      new(*addresses).get
    end

    def self.general_error_message
      "The address you entered could not be verified"
    end

    def self.confirm_message
      "#{general_error_message}.  Would you like to save this address even though it can not be verified?"
    end

    def url
      Rails.env.production? ? USPS_CONFIG["address_verification_url"] : USPS_CONFIG["address_verification_test_url"]
    end

    def api_key
      @api_key = "Verify"
    end

    def split_zip(zip)
      zip.to_s.match(/(^\d{5})-*(\d{0,}$)/)&.captures
    end

    def join_zip(zip_array = [])
      zip_array.reject(&:blank?).join("-")
    end


    def build_xml
      build do |builder|
        @addresses.each_with_index do |address_object, index|
          address_object = address_object.attributes if address_object.respond_to?(:attributes)
          zip5, zip4 = split_zip(address_object["zip"])
          builder.tag!('Address', :ID => index) do

            # Address fields are swapped in the USPS API
            builder.tag!('Address1', address_object["address2"].to_s)
            builder.tag!('Address2', address_object["address"].to_s)

            builder.tag!('City', address_object["city"].to_s)
            builder.tag!('State', address_object["state"].to_s)

            builder.tag!('Zip5', zip5.to_s)
            builder.tag!('Zip4', zip4.to_s)
          end
        end

      end
    end

    def api_type
      @api_type ||= 'AddressValidateRequest'
    end

    def error?
      error_hash.present?
    end

    def error_hash
      (inner_response || {})["Error"] || {}
    end

    def error_description
      error_hash["Description"]
    end

    def inner_response
      response.dig("AddressValidateResponse","Address")
    end

    def return_text
      inner_response&.[]("ReturnText")
    end

    def parsed_address_response
      return {"error" => error_description} if error?
      zip = join_zip(inner_response.slice("Zip5", "Zip4").values)
      attributes = {"zip" => zip}
      inner_response.each do |key, value|
        new_key = ADDRESS_KEY_DECODER.invert[key] || key
        attributes[new_key] = filter_address_values(new_key, value) if value.present? && new_key.present?
      end
      attributes
    end

    def filter_address_values(key, value)
      return value unless DECODED_ADDRESS_KEYS.include?(key) && value.respond_to?(:capitalize)
      if key == "state" && value.length == 2
        value.upcase
      else
        value.squish.split(" ").map(&:capitalize).join(" ")
      end
    end

    def parsed_attributes_for_update
      parsed_address_response.slice(*(DECODED_ADDRESS_KEYS))
    end
  end
end
