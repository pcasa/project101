class CreateServiceGroups < ActiveRecord::Migration
  def self.up
    create_table :service_groups do |t|
      t.string :name, :limit => 64
      t.string :short_description, :limit => 256
      t.decimal :cost, :precision => 12, :scale => 2
      t.decimal :price, :precision => 12, :scale => 2
      t.boolean :new_service
      t.boolean :deleted
      t.integer :category_id
      t.timestamps
    end
    add_index(:service_groups, [:name, :short_description, :price, :cost, :new_service, :deleted, :category_id], :unique => true, :name => 'add_index_to_service_groups_n_sd_p_c_ns_da_ci')
  end

  def self.down
    drop_table :service_groups
  end
end
