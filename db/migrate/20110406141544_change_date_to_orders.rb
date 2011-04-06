class ChangeDateToOrders < ActiveRecord::Migration
  def self.up
    change_column(:orders, :closed_date, :datetime)
  end

  def self.down
    change_column(:orders, :closed_date, :date)
  end
end
