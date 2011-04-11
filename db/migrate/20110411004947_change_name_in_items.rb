class ChangeNameInItems < ActiveRecord::Migration
  def self.up
    remove_index(:items, [:new_service, :deleted, :visible, :closed])
    remove_index(:items, [:name, :price, :cost, :qty, :parent_id])
    change_column(:items, :name, :string, :limit => 128)
    add_index(:items, [:new_service, :deleted, :visible, :closed], :name => "add_index_to_items_on_ns_d_v_c")
    add_index(:items, [:name, :price, :cost, :qty, :parent_id], :name => "add_index_to_items_n_p_c_q_pi")
  end

  def self.down
    remove_index(:items, [:name, :price, :cost, :qty, :parent_id], :name => "add_index_to_items_n_p_c_q_pi")
    remove_index(:items, [:new_service, :deleted, :visible, :closed], :name => "add_index_to_items_on_ns_d_v_c")
    change_column(:items, :name, :string, :limit => 64 )
    add_index(:items, [:new_service, :deleted, :visible, :closed])
    add_index(:items, [:name, :price, :cost, :qty, :parent_id])
  end
end
