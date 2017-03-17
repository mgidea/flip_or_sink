class ZipCode < ApplicationRecord
  belongs_to :city, :inverse_of => :zip_codes
end
