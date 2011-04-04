class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name
      t.string :subdomain
      t.integer :parent_id
      t.timestamps
    end
    add_index(:companies, [:name, :subdomain])
  end

  def self.down
    drop_table :companies
  end
end
