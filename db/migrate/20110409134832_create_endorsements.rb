class CreateEndorsements < ActiveRecord::Migration
  def self.up
    create_table :endorsements do |t|
      t.integer :insurance_policy_id
      t.string :name
      t.decimal :previous_payment_amount, :precision => 7, :scale => 2
      t.decimal :partial_payment_amount, :precision => 7, :scale => 2
      t.decimal :new_payment_amount, :precision => 7, :scale => 2
      t.decimal :club_price, :precision => 7, :scale => 2
      t.boolean :invoiced, :default => false
      t.timestamps
    end
    add_index(:endorsements, :insurance_policy_id)
    add_index(:endorsements, [:previous_payment_amount, :partial_payment_amount, :new_payment_amount, :club_price, :invoiced ], :name => "add_index_to_endorsements_ppa_ppa_npa_cp_i")
  end

  def self.down
    drop_table :endorsements
  end
end
