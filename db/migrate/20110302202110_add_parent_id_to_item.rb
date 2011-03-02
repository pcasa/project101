class AddParentIdToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :parent_id, :integer
    add_index(:items, :parent_id)
  end

  def self.down
    remove_index(:items, :parent_id)
    remove_column :items, :parent_id
  end
end
