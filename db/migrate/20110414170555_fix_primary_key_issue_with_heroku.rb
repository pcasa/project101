class FixPrimaryKeyIssueWithHeroku < ActiveRecord::Migration
  def self.up
    execute 'SELECT setval('categories_id_seq'::regclass, MAX(id)) FROM categories;'
  end

  def self.down
  end
end
