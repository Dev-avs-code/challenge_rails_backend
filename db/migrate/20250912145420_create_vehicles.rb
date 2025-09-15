class CreateVehicles < ActiveRecord::Migration[7.2]
  def change
    create_table :vehicles do |t|
      t.string :vin, null: false
      t.string :plate, null: false
      t.string :brand, null: false
      t.string :model, null: false
      t.string :year, null: false
      t.string :status, null: false
      t.timestamps
    end

    add_index :vehicles, 'lower(vin)', unique: true, name: 'index_vehicles_on_lower_vin'
    add_index :vehicles, 'lower(plate)', unique: true, name: 'index_vehicles_on_lower_plate'
    add_index :vehicles, :status
  end
end
