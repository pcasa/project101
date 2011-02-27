class CreateSpecialServices < ActiveRecord::Migration
  def self.up
    create_table :special_services do |t|
      t.integer :service_id
      t.integer :service_group_id
      t.timestamps
    end
    add_index(:special_services, [:service_id, :service_group_id ], :unique => true, :name => 'add_index_to_special_services_si_sgi')
  end

  def self.down
    drop_table :special_services
  end
end
