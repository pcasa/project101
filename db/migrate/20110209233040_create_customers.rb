class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.string :firstname
      t.string :lastname
      t.string :customer_number
      t.string :street1
      t.string :street2
      t.string :city, :limit => 64
      t.string :state, :limit => 64
      t.string :zipcode, :limit => 16
      t.string :full_address
      t.integer :parent_company_id
      t.integer :assigned_company_id
      t.timestamps
    end
    add_index(:customers, [ :firstname, :lastname, :customer_number, :full_address ], :name => "index_customers_on_fn_and_ln_and_cn_and_fa")
    add_index(:customers, [:parent_company_id, :assigned_company_id ])
  end

  def self.down
    drop_table :customers
  end
end
