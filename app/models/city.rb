class City < ApplicationRecord
  belongs_to :state, :inverse_of => :cities
  belongs_to  :county, :inverse_of => :cities, :optional => true
  has_many  :zip_codes, :inverse_of => :city, :autosave => true
end
