class RemoveUniqueIndexFromVendors < ActiveRecord::Migration
  def self.up
    remove_index(:vendors, [:name, :contact, :phone])
    add_index(:vendors, [:name, :contact, :phone], :unique => false)
  end

  def self.down
    remve_index(:vendors, [:name, :contact, :phone])
    add_index(:vendors, [:name, :contact, :phone], :unique => true)
  end
end
