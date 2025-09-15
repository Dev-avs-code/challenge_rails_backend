class CreateMaintenanceServices < ActiveRecord::Migration[7.2]
  def change
    create_table :maintenance_services do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.string :description, null: false
      t.string :status, null: false
      t.decimal :cost_cents, null: false, precision: 10, scale: 2
      t.string :priority, null: false
      t.datetime :completed_at, null: true
      t.timestamps
    end

    add_index :maintenance_services, :status
    add_index :maintenance_services, :priority
    add_index :maintenance_services, :completed_at
  end
end
