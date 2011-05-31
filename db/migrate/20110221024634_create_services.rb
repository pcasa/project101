class CreateServices < ActiveRecord::Migration
  def self.up
    create_table :services do |t|
      t.string :name, :limit => 64
      t.string :short_description, :limit => 256
      t.decimal :price, :precision => 7, :scale => 2
      t.decimal :cost, :precision => 7, :scale => 2
      t.boolean :visible
      t.boolean :new_service
      t.boolean :deleted
      t.boolean :disabled
      t.integer :category_id
      t.timestamps
    end
    add_index(:services, [:name, :category_id], :unique => false)
    add_index(:services, :short_description)
    add_index(:services, [:price, :cost, :visible])
    add_index(:services, [:new_service, :deleted, :disabled])
  end

  def self.down
    drop_table :services
  end
end
