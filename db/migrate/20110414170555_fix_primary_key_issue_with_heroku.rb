class FixPrimaryKeyIssueWithHeroku < ActiveRecord::Migration
  def self.up
    execute "SELECT setval('category_id_seq', 10000);"
  end

  def self.down
  end
end
