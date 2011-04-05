class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name
      t.string :subdomain
      t.integer :parent_id
      t.string :phone_number
      t.string :street1
      t.string :street2
      t.string :city, :limit => 64
      t.string :state, :limit => 64
      t.string :zipcode, :limit => 16
      t.string :full_address
      t.timestamps
    end
    add_index(:companies, [:name, :subdomain])
  end

  def self.down
    drop_table :companies
  end
end
