class FixPrimaryKeyIssueWithHeroku < ActiveRecord::Migration
  def self.up
   # execute "SELECT setval('categories_id_seq', 30);"
   # execute "SELECT setval('companies_id_seq', 30);"
  end

  def self.down
  end
end
