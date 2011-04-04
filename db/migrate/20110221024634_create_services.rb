class CreateServices < ActiveRecord::Migration
  def self.up
    create_table :services do |t|
      t.string :name, :limit => 64
      t.string :short_description, :limit => 256
      t.decimal :price, :precision => 7, :scale => 2
      t.decimal :cost, :precision => 7, :scale => 2
      t.boolean :visible
      t.boolean :new_service
      t.boolean :deleted
      t.boolean :disabled
      t.integer :category_id
      t.timestamps
    end
    add_index(:services, [:name, :short_description, :price, :cost, :visible, :new_service, :deleted, :category_id, :disabled], :unique => true, :name => 'add_index_to_services_n_sd_p_c_v_ns_da_ci')
  end

  def self.down
    drop_table :services
  end
end
