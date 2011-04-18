class FixNewServiceOnItems < ActiveRecord::Migration
  def self.up
    change_column(:items, :new_service, :boolean, :default => false)
  end

  def self.down
    change_column(:items, :new_service, :boolean, :default => nil)
  end
end
