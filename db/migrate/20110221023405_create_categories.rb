class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth
      t.timestamps
    end
    add_index(:categories, [:name, :parent_id, :lft, :rgt, :depth], :name => "add_index_to_categories_n_pi_l_r_dpth")
  end

  def self.down
    drop_table :categories
  end
end
