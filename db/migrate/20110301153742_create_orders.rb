class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :assigned_company_id
      t.integer :parent_company_id
      t.integer :customer_id
      t.integer :user_id
      t.boolean :closed, :default => false
      t.datetime :closed_date
      t.string :payment_type, :limit => 16
      t.decimal :total_cost, :precision => 7, :scale => 2
      t.decimal :total_amount, :precision => 7, :scale => 2
      t.decimal :amount_paid, :precision => 7, :scale => 2
      t.string :override, :limit => 6
      t.timestamps
    end
    add_index(:orders, [:assigned_company_id, :parent_company_id])
    add_index(:orders, :customer_id)
    add_index(:orders, [:closed, :closed_date])
    add_index(:orders, [:payment_type, :total_cost, :total_amount], :name => "add_index_to_orders_pt_tc_ta")
    add_index(:orders, :amount_paid)
    add_index(:orders, :override)
  end

  def self.down
    drop_table :orders
  end
end
