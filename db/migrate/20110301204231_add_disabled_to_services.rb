class AddDisabledToServices < ActiveRecord::Migration
  def self.up
    add_column :services, :disabled, :boolean
  end

  def self.down
    remove_column :services, :disabled
  end
end
