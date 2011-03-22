class AddAmountsToInsurancePolicies < ActiveRecord::Migration
  def self.up
    add_column :insurance_policies, :first_payment, :decimal, :precision => 12, :scale => 2
    add_column :insurance_policies, :monthly_payment, :decimal, :precision => 12, :scale => 2
  end

  def self.down
    remove_column :insurance_policies, :monthly_payment
    remove_column :insurance_policies, :first_payment
  end
end
