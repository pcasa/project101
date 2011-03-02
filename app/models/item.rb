class Item < ActiveRecord::Base
  belongs_to :order, :class_name => "Order", :foreign_key => "order_id"
  belongs_to :customer, :class_name => "Customer", :foreign_key => "customer_id"
  belongs_to :category, :class_name => "Category", :foreign_key => "category_id"
  belongs_to :service, :class_name => "Service", :foreign_key => "service_id"
  belongs_to :service_group, :class_name => "ServiceGroup", :foreign_key => "service_group_id"
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  belongs_to :assigned_company, :class_name => "Company", :foreign_key => "assigned_company_id"
  belongs_to :parent_company, :class_name => "Company", :foreign_key => "parent_company_id"
  
  
    attr_accessible :name, :short_description, :category_id, :cost, :price, :qty, :visible, :new_service, :deleted, :closed, :order_id, :customer_id, :itemable, :parent_id, :itemable_type, :itemable_id, :user_id, :assigned_company_id, :parent_company_id
    
    
    
    belongs_to :itemable, :polymorphic => true
    
    
    def full_price
        (price*qty)
    end
end
