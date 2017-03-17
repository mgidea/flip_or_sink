class CreateStates < ActiveRecord::Migration[5.0]
  def change
    create_table :states do |t|
      t.string :name
      t.string :abbreviation
      t.string :code
      t.string :geo_key
      t.float  :geo_center_latitude
      t.float  :geo_center_longitude
      t.string :country

      t.timestamps
    end
  end
end
