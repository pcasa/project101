class AddDeletedAtToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :deleted_at, :datetime
    add_index :items, :deleted_at
  end

  def self.down
    remove_index :items, :deleted_at
    remove_column :items, :deleted_at
  end
end
