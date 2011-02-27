class AddInfoToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :firstname, :string, :limit => 64
    add_column :users, :lastname, :string, :limit => 64
    add_column :users, :username, :string, :limit => 32
    add_column :users, :passcode, :string, :limit => 8
    add_column :users, :role, :string, :limit => 16
    add_index :users, :passcode,                :unique => true
    add_index :users, :role
    # Create the seed data  
    
  end

  def self.down
    remove_column :users, :role
    remove_column :users, :passcode
    remove_column :users, :username
    remove_column :users, :lastname
    remove_column :users, :firstname
    remove_index :users, :passcode
    remove_index :users, :role
  end
end
