class InsurancePolicy < ActiveRecord::Base
  
    attr_accessible :policy_number, :yearly, :customer_id, :vendor_id, :assigned_company_id, :parent_company_id, :due_date, :cancelled, :completed, :number_of_payments_left
    belongs_to :customer, :class_name => "Customer", :foreign_key => "customer_id"
    belongs_to :vendor, :class_name => "Vendor", :foreign_key => "vendor_id"
    
    
    def setbase
      self.attributes = {:cancelled => false, :completed => false}
    end
end
