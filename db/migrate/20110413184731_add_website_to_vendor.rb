class AddWebsiteToVendor < ActiveRecord::Migration
  def self.up
    add_column :vendors, :website, :string
  end

  def self.down
    remove_column :vendors, :website
  end
end
