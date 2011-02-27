class AddSubdomainToCompanies < ActiveRecord::Migration
  def self.up
    add_column :companies, :subdomain, :string
    add_index :companies, :subdomain
  end

  def self.down
    remove_index :companies
    remove_column :companies, :subdomain
  end
end
