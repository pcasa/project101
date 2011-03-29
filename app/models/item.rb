class Item < ActiveRecord::Base
  acts_as_paranoid
  
  # item.only_deleted # retrieves the deleted records
  # item.with_deleted # retrieves all records, deleted or not
  
  # To Really delete a record
  # item.destroy!
  # Item.delete_all!(conditions)
  
  belongs_to :order, :class_name => "Order", :foreign_key => "order_id"
  belongs_to :customer, :class_name => "Customer", :foreign_key => "customer_id"
  belongs_to :category, :class_name => "Category", :foreign_key => "category_id"
  belongs_to :service, :class_name => "Service", :foreign_key => "service_id"
  belongs_to :service_group, :class_name => "ServiceGroup", :foreign_key => "service_group_id"
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  belongs_to :assigned_company, :class_name => "Company", :foreign_key => "assigned_company_id"
  belongs_to :parent_company, :class_name => "Company", :foreign_key => "parent_company_id"
  belongs_to :insurance_policy, :class_name => "InsurancePolicy"
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  belongs_to :vendor, :class_name => "Vendor", :foreign_key => "vendor_id"
  
  
  attr_accessible :name, :short_description, :category_id, :cost, :price, :qty, :visible, :new_service, :deleted, :closed, :order_id, :customer_id, :itemable, :parent_id, :itemable_type, :itemable_id, :user_id, :assigned_company_id, :parent_company_id, :schedule_any_tasks, :vendor_id
  
  scope :valid_items, where(:closed => true)
  scope :in_orders_with, lambda { |orders, type| where('itemable_type IS ?', type).joins(:order) & orders }
    
    
    
    belongs_to :itemable, :polymorphic => true
    
    has_many :children, :class_name => "Item", :foreign_key => "parent_id"
    
    
    def full_price
        (price*qty)
    end
    
    def schedule_any_tasks
      if (self.itemable_type == "InsurancePolicy") && (self.name == "Policy Payment")
        @policy = InsurancePolicy.find(self.itemable_id)
        message = "Call " + @policy.customer.full_name + " to remind them about there payment"
        @current_policy_task = @policy.tasks.first
        if self.new_service?  || @current_policy_task.blank?
          Task.create!(:asset_type => self.itemable_type, :asset_id => self.itemable_id, :user_id => self.user_id, :assigned_to => self.user_id, :assigned_company => self.assigned_company, :category => "call", :name => message, :due_at => @policy.due_date - 5.days)
          @policy.decrement!(:number_of_payments_left, 1)
        else
           @current_policy_task.mark_as_completed(self.user_id) 
           Task.create!(@current_policy_task.attributes.merge(:due_at => @current_policy_task.due_at + 30.days, :deleted_at => nil))
           @policy.decrement!(:number_of_payments_left, 1)
        end
      end
    end
end
