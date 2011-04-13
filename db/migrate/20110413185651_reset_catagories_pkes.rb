class ResetCatagoriesPkes < ActiveRecord::Migration
  def self.up
    remove_index(:categories, [:name, :parent_id, :lft, :rgt, :depth])
    add_index(:categories, [:name, :parent_id, :lft, :rgt, :depth], :name => "add_index_to_categories_n_pi_l_r_dpth")
    remove_index(:companies, [:name, :subdomain])
    add_index(:companies, [:name, :subdomain])
  end

  def self.down
    remove_index(:categories, [:name, :parent_id, :lft, :rgt, :depth])
    add_index(:categories, [:name, :parent_id, :lft, :rgt, :depth], :name => "add_index_to_categories_n_pi_l_r_dpth")
    remove_index(:companies, [:name, :subdomain])
    add_index(:companies, [:name, :subdomain])
  end
end
