class InsurancePolicy < ActiveRecord::Base
  
    attr_accessible :policy_number, :yearly, :customer_id, :vendor_id, :assigned_company_id, :parent_company_id, :due_date, :cancelled, :completed, :number_of_payments_left, :parent_id, :policy_type, :policy_payments, :first_payment, :monthly_payment
    belongs_to :customer, :class_name => "Customer", :foreign_key => "customer_id"
    belongs_to :vendor, :class_name => "Vendor", :foreign_key => "vendor_id"
    has_many :children, :class_name => "InsurancePolicy", :foreign_key => "parent_id"
    has_many :items, :as => :itemable
    has_many :policy_payments, :through => :items
    
    scope :new_policies, where("policy_type='New'")
    scope :renewal, where("policy_type='Renewal'")
    scope :reinstated, where("policy_type='Reinstate'")
    
    validates_presence_of :policy_number, :customer_id, :vendor_id, :due_date, :number_of_payments_left, :policy_type, :first_payment, :monthly_payment, :message => "can't be blank"
    
    POLICYTYPE = %w[New Renewal Reinstate]
    
    
    def setbase
      self.attributes = {:cancelled => false, :completed => false}
    end
    
    
    
    def add_new_payment(current_order, user_id, assigned_company_id, parent_company_id)
      # remove one payment since customer is making one now
      payments_left = self.number_of_payments_left - 1
      temp_desc = "Payment on policy #" + self.policy_number + " from " + self.vendor.name + ".  "
      if payments_left > 1
        temp_desc2 = "You have " + payments_left.to_s + " payments left."
      elsif payments_left == 0
        temp_desc2 = "This is your last payment.  If you have any questions about your renewal, please feel free to ask us."
      else
        temp_desc2 = "You have " + payments_left.to_s + " payment left.  Your renewal is comming up."
      end
      if self.policy_type == "New" 
        payment_amount = self.first_payment 
      else 
        payment_amount = self.monthly_payment 
      end
      full_desc = temp_desc + temp_desc2
      Item.create!(:name => "Policy Payment", :short_description => full_desc, :visible => true, :new_service => true, :itemable => self, :user_id => user_id, :customer_id => 1, :order_id => current_order.id, :parent_company_id => parent_company_id, :assigned_company_id => assigned_company_id, :cost => payment_amount, :price => payment_amount, :qty => 1)
      current_order.update_attribute(:customer_id, 1)
      
    end
    
end
