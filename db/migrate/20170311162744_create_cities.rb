class CreateCities < ActiveRecord::Migration[5.0]
  def change
    create_table :cities do |t|
      t.string :name
      t.string :code
      t.string :geo_key
      t.float  :geo_center_latitude
      t.float  :geo_center_longitude
      t.references :state
      t.references :county

      t.timestamps
    end
  end
end
