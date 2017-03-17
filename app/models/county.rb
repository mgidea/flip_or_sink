class County < ApplicationRecord
  CODE_TYPE = "CO"

  DECODER = {"id" => "code"}

  belongs_to :state, :inverse_of => :counties
  has_many :cities, :inverse_of => :county, :autosave => true
  has_many :zip_codes, :through => :cities

  def self.import_state_counties(state, counties)
    counties.map do |county_hash|
      if county_name = county_hash["name"]
        updated_hash = county_hash.except("type").map{|key, value| [DECODER[key] || key, value]}.to_h
        next if county = state.counties.find_by_name(county_name)
        state.counties.create(updated_hash)
      end
    end
  end

  def import_state_county(state, county_hash)
    if county_name = county_hash["name"]
      updated_hash = county_hash.except("type").map{|key, value| [DECODER[key] || key, value]}.to_h
      unless county = state.counties.find_by_name(county_name)
        state.counties.create(updated_hash)
      end
    end
  end
end
