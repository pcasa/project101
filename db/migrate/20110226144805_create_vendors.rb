class CreateVendors < ActiveRecord::Migration
  def self.up
    create_table :vendors do |t|
      t.string :name, :limit => 64
      t.string :contact, :limit => 64
      t.string :phone, :limit => 16
      t.timestamps
    end
    add_index(:vendors, [:name, :contact, :phone], :unique => true)
  end

  def self.down
    drop_table :vendors
  end
end
