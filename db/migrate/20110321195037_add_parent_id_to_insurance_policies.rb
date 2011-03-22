class AddParentIdToInsurancePolicies < ActiveRecord::Migration
  def self.up
    add_column :insurance_policies, :parent_id, :integer
    add_column :insurance_policies, :policy_type, :string, :limit => 64
    add_index :insurance_policies, :parent_id
    add_index :insurance_policies, :policy_type
  end

  def self.down
    remove_index :insurance_policies, :parent_id
    remove_index :insurance_policies, :policy_type
    remove_column :insurance_policies, :policy_type
    remove_column :insurance_policies, :parent_id
  end
end
