class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :street1
      t.string :street2
      t.string :city, :limit => 64
      t.string :state, :limit => 64
      t.string :zipcode, :limit => 16
      t.datetime :deleted_at
      t.string :address_type, :limit => 32
      t.string :addressable_type
      t.integer :addressable_id
      t.boolean :current
      t.string :full_address
      t.timestamps
    end
    add_index(:addresses, [ :addressable_id, :addressable_type ])
  end

  def self.down
    drop_table :addresses
  end
end
