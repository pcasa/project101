class CreateInsurancePolicies < ActiveRecord::Migration
  def self.up
    create_table :insurance_policies do |t|
      t.string :policy_number, :limit => 24
      t.boolean :yearly, :default => false
      t.integer :customer_id
      t.integer :vendor_id
      t.integer :assigned_company_id
      t.integer :parent_company_id
      t.date :due_date
      t.boolean :cancelled
      t.boolean :completed
      t.integer :number_of_payments_left
      t.timestamps
    end
    add_index(:insurance_policies, [:policy_number, :customer_id, :assigned_company_id, :parent_company_id, :cancelled, :completed], :name => "add_index_to_insurance_policies_pn_ci_aci_pci_c_c")
    add_index(:insurance_policies, :due_date)
    add_index(:insurance_policies, :number_of_payments_left)
  end

  def self.down
    drop_table :insurance_policies
  end
end
