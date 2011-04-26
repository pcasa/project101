class FixTodaysEntries < ActiveRecord::Migration
  def self.up
    @company = Company.find_by_name("norcross")
    @user = User.find_by_username("MARLEN")
    @tasks = Task.where("created_at > ?", Time.now.beginning_of_day)
    @customers = Customer.where("created_at > ?", Time.now.beginning_of_day)
    @tasks.each do |task|
      task.update_attributes!(:assigned_to => 4, :assigned_company => 2)
    end
    @customers.each do |customer|
      customer.update_attributes!(:assigned_company_id => 2)
    end
  end

  def self.down
  end
end
