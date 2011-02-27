class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.integer :parent_id
      t.timestamps
    end
    add_index(:categories, [:name, :parent_id])
  end

  def self.down
    drop_table :categories
  end
end
