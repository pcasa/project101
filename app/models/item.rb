class Item < ActiveRecord::Base
  acts_as_paranoid
  
  # item.only_deleted # retrieves the deleted records
  # item.with_deleted # retrieves all records, deleted or not
  
  # To Really delete a record
  # item.destroy!
  # Item.delete_all!(conditions)
  
#  default_scope order('id DESC')
  
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
  
  
  attr_accessible :name, :short_description, :category_id, :cost, :price, :qty, :visible, :new_service, :deleted, :closed, :order_id, :customer_id, :itemable, :parent_id, :itemable_type, :itemable_id, :user_id, :assigned_company_id, :parent_company_id, :schedule_any_tasks, :vendor_id, :created_at, :deleted_at, :updated_at
  
  
  scope :valid_items, where(:closed => true)
  scope :in_orders_with, lambda { |orders, type| where("itemable_type = ?", type.to_s).joins(:order) & orders }
  
  scope :in_orders, lambda { |orders| joins(:order) & orders }
  scope :only_new_items, where(:new_service => true)
    
    
    
    belongs_to :itemable, :polymorphic => true
    
    has_many :children, :class_name => "Item", :foreign_key => "parent_id"
    
    validates_numericality_of :price, :cost, :allow_nil => true
    
    
    def full_price
        (price*qty)
    end
    
    def schedule_any_tasks
      if (self.itemable_type == "InsurancePolicy")
        if name == "Policy Payment" || name == "Endorsement and Policy Payment" || name == "Endorsement Payment"
          self.itemable.schedule_policy_task(self.itemable, self.user_id, self.assigned_company_id, self)
        end
      end
    end
end
