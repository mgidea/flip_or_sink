class ZipCodeCsv
  attr_accessor :filename, :csv
  def initialize(filename)
    @filename = filename
    @csv = CSV.read(filename, :headers => true)
  end

  HEADERS = {

  }

  def process_csv
    ZipCode.transaction do
      puts "*" * 50
      @csv.each_with_index do |row, index|
        puts (index + 1).to_s
        hashed_row = row.to_hash
        postal_code = hashed_row["Postal Code"]
        city_name = hashed_row["Place Name"]
        state_name = hashed_row["State"]
        state_abbreviation = hashed_row["State Abbreviation"]
        county_name = hashed_row["County"]
        latitude = hashed_row["Latitude"]
        longitude = hashed_row["Longitude"]
        if postal_code.blank?
          puts "Missing Postal Code, Moving on to next row"
          next
        else
          puts "Finding State with Abbreviation: #{state_abbreviation}"
          state = State.where(:abbreviation => state_abbreviation).first_or_create
          puts "#{state.new_record? ? "Created new State" : "Found existing State"}"
          puts "Finding #{state.name} county with name: #{county_name}"
          county = state.counties.where(:name => county_name).first_or_create
          puts "#{county.new_record? ? "Created new #{state.name} county" : "Found existing #{state.name} county"}"
          puts "Finding #{state.name} city with name: #{city_name}"
          city = state.cities.where(:name => city_name).first_or_create
          puts "#{city.new_record? ? "Built new #{state.name} city" : "Found existing #{state.name} city"}"
          city.county = county if county && city.county_id.blank?
          city.assign_attributes(:geo_center_latitude => latitude.to_f, :geo_center_longitude => longitude.to_f)
          puts "Finding or creating #{city.name} zip code with Postal Code: #{postal_code}"
          zip_code = city.zip_codes.where(postal_code: normalize_postal_code(postal_code)).first_or_initialize
          city.save
          puts "#{zip_code.new_record? ? "Created new Zip Code" : "Found existing Zip Code"}"
        end
        puts "#" * 50
      end
    end
    self
  end

  def normalize_postal_code(postal_code)
    postal_code.to_s.rjust(5, "0")
  end
end
# file_name = "#{Rails.root}/lib/static_data/us_postal_codes.csv"; zip_code_csv = ZipCodeCsv.new(file_name);  zip_code_csv.process_csv
