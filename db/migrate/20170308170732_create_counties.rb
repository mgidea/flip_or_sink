class CreateCounties < ActiveRecord::Migration[5.0]
  def change
    create_table :counties do |t|
      t.string :name
      t.string :code
      t.string :geo_key
      t.float  :geo_center_latitude
      t.float  :geo_center_longitude
      t.references :state

      t.timestamps
    end
  end
end
