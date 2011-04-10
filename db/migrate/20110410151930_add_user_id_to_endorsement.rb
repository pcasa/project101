class AddUserIdToEndorsement < ActiveRecord::Migration
  def self.up
    add_column :endorsements, :user_id, :integer
    add_index(:endorsements, :user_id)
  end

  def self.down
    remove_index(:endorsements, :user_id)
    remove_column :endorsements, :user_id
  end
end
