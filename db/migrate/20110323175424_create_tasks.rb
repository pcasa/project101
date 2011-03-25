class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.integer :user_id
      t.integer :assigned_to
      t.integer :completed_by
      t.integer :assigned_company
      t.string :name, :default => ""
      t.integer :asset_id
      t.string :asset_type
      t.string :category
      t.datetime :due_at
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :tasks, [ :user_id, :name, :deleted_at ]
    add_index :tasks, :assigned_to
    add_index :tasks, :assigned_company
    add_index :tasks, :deleted_at
  end

  def self.down
    drop_table :tasks
  end
end
