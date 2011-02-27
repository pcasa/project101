class CreateEmploymentships < ActiveRecord::Migration
  def self.up
    create_table :employmentships do |t|
      t.integer :company_id
      t.integer :user_id

      t.timestamps
    end
    
    add_index :employmentships, :company_id
    add_index :employmentships, :user_id
    add_index :employmentships, [:company_id, :user_id], :unique => true
  end

  def self.down
    drop_table :employmentships
  end
end
