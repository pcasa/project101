class FixPrimaryKeyIssueWithHeroku < ActiveRecord::Migration
  def self.up
    execute 'SELECT setval('category_id_seq'::regclass, MAX(id)) FROM category;'
  end

  def self.down
  end
end
