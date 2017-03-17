class CreateZipCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :zip_codes do |t|
      t.string :postal_code
      t.string :code
      t.string :geo_key
      t.float  :geo_center_latitude
      t.float  :geo_center_longitude
      t.references :city

      t.timestamps
    end
  end
end
