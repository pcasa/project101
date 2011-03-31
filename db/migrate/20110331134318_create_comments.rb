class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text :content
      t.string :commentable_type
      t.integer :commentable_id
      t.timestamps
    end
    add_index(:comments, [:commentable_type, :commentable_id])
  end

  def self.down
    drop_table :comments
  end
end
