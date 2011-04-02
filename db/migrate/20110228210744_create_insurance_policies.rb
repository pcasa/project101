class CreateInsurancePolicies < ActiveRecord::Migration
  def self.up
    create_table :insurance_policies do |t|
      t.string :policy_number, :limit => 24
      t.boolean :yearly, :default => false
      t.integer :customer_id
      t.integer :vendor_id
      t.integer :assigned_company_id
      t.integer :parent_company_id
      t.decimal :down_payment, :precision => 7, :scale => 2
      t.decimal :club_price, :precision => 7, :scale => 2
      t.decimal :monthly_payment, :precision => 7, :scale => 2
      t.date :due_date
      t.boolean :cancelled
      t.boolean :completed
      t.integer :number_of_payments_left
      t.integer :parent_id
      t.string :policy_type, :limit => 64
      t.timestamps
    end
    add_index(:insurance_policies, [:policy_number, :customer_id, :assigned_company_id, :parent_company_id, :cancelled, :completed, :club_price], :name => "add_index_to_insurance_policies_pn_ci_aci_pci_c_c_cp")
    add_index(:insurance_policies, :due_date)
    add_index(:insurance_policies, :number_of_payments_left)
    add_index(:insurance_policies, :parent_id)
    add_index(:insurance_policies, :policy_type)
  end

  def self.down
    drop_table :insurance_policies
  end
end
