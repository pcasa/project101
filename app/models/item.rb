class Item < ActiveRecord::Base
    attr_accessible :name, :short_description, :category_id, :cost, :price, :qty, :visible, :new_service, :deleted, :closed, :order_id, :itemable_type, :itemable_id, :user_id, :assigned_company_id, :parent_company_id
    
    
    
    belongs_to :itmable, :polymorphic => true
end
