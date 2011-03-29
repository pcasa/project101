class AddVendorIdToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :vendor_id, :integer
    add_index(:items, :vendor_id)
    policies = InsurancePolicy.find(:all)
    for policy in policies
      unless policy.items.blank?
        for item in policy.items
          item.update_attribute(:vendor_id, policy.vendor_id)
        end
      end
    end
  end

  def self.down
    remove_index(:items, :vendor_id)
    remove_column :items, :vendor_id
  end
end
