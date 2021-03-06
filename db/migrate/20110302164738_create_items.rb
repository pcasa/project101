class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :name, :limit => 64
      t.string :short_description, :limit => 256
      t.decimal :price, :precision => 7, :scale => 2
      t.decimal :cost, :precision => 7, :scale => 2
      t.integer :qty, :default => 1
      t.boolean :visible, :default => true
      t.boolean :new_service
      t.boolean :deleted, :default => false
      t.boolean :closed, :default => false
      t.integer :order_id
      t.integer :category_id
      t.references :itemable, :polymorphic => true
      t.integer :vendor_id
      t.integer :user_id
      t.integer :customer_id
      t.integer :assigned_company_id
      t.integer :parent_company_id
      t.integer :parent_id
      t.datetime :deleted_at
      t.timestamps
    end
    add_index(:items, [:name, :price, :cost, :qty, :parent_id])
    add_index(:items, [:itemable_type, :itemable_id])
    add_index(:items, [:order_id, :vendor_id])
    add_index(:items, [:new_service, :deleted, :visible, :closed])
    add_index(:items, :customer_id)
    add_index(:items, [:user_id, :assigned_company_id, :parent_company_id], :name => 'add_index_to_items_usr_assgn_comp_prnt_comp')
    add_index(:items, :deleted_at)
  end

  def self.down
    drop_table :items
  end
end
