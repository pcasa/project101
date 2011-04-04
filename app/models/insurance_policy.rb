class InsurancePolicy < ActiveRecord::Base
  
    attr_accessible :policy_number, :yearly, :customer_id, :vendor_id, :assigned_company_id, :parent_company_id, :due_date, :cancelled, :completed, :number_of_payments_left, :parent_id, :policy_type, :down_payment, :monthly_payment, :club_price
    belongs_to :customer, :class_name => "Customer", :foreign_key => "customer_id"
    belongs_to :vendor, :class_name => "Vendor", :foreign_key => "vendor_id"
    has_many :children, :class_name => "InsurancePolicy", :foreign_key => "parent_id"
    has_many :items, :as => :itemable
    has_many :tasks, :as => :asset
    
    scope :new_policies, where("policy_type='New'")
    scope :renewal, where("policy_type='Renewal'")
    scope :reinstated, where("policy_type='Reinstate'")
    
    validates_presence_of :policy_number, :customer_id, :vendor_id, :due_date, :number_of_payments_left, :policy_type, :down_payment, :monthly_payment, :club_price, :message => "can't be blank"
    
    validates_numericality_of :number_of_payments_left, :down_payment, :monthly_payment, :allow_nil => true
    
    POLICYTYPE = %w[New Renewal Reinstate]
    
    
    def setbase
      self.attributes = {:cancelled => false, :completed => false}
    end
    
    
    
    
    def add_new_payment(current_order, user_id, assigned_company, parent_company_id, true_or_false)
      # remove one payment since customer is making one now
      payments_left = self.number_of_payments_left - 1
      temp_desc = "Payment on policy #" + self.policy_number + " from " + self.vendor.name + ".  "
      if payments_left > 1
        temp_desc2 = "You have " + payments_left.to_s + " payments left.  Your next payment is on #{(self.due_date + 30.days).strftime('%b %d %Y')}"
      elsif payments_left == 0
        temp_desc2 = "This is your last payment.  If you have any questions about your renewal, please feel free to ask us."
      else
        temp_desc2 = "You have " + payments_left.to_s + " payment left.  Your renewal is comming up.  Your Renewal will be on #{(self.due_date + 30.days).strftime('%b %d, %Y')}"
      end
      if self.items.blank? 
        payment_amount = self.down_payment 
        sale_price = payment_amount + club_price
      else 
        payment_amount = self.monthly_payment 
        sale_price = self.monthly_payment
      end
      full_desc = temp_desc + temp_desc2
      current_order.update_attribute(:customer_id, self.customer_id)
      Item.create!(:name => "Policy Payment", :short_description => full_desc, :visible => true, :new_service => true_or_false, :itemable => self, :user_id => user_id, :customer_id => self.customer_id, :order_id => current_order.id, :parent_company_id => parent_company_id, :assigned_company_id => assigned_company.id, :cost => payment_amount, :price => sale_price, :qty => 1, :category_id => Category.find_by_name("Insurance Policy").id, :vendor_id => self.vendor_id)
      unless self.items.blank?
        Item.create!(:name => "Processing Fee", :short_description => "Processing Fee", :visible => true, :new_service => true_or_false, :itemable => assigned_company, :user_id => user_id, :customer_id => self.customer_id, :order_id => current_order.id, :parent_company_id => parent_company_id, :assigned_company_id => assigned_company.id, :cost => "0.00", :price => "2.00", :qty => 1, :category_id => Category.find_by_name("Profit").id)
      end
    end
    
    def schedule_policy_task(policy, user_id, current_company_id)
      message = "Call " + policy.customer.full_name + " to remind them about there payment."
      current_policy_task = policy.tasks.first
      if policy.number_of_payments_left >= 1
        if current_policy_task.blank?
          Task.create!(:asset => policy, :user_id => user_id, :assigned_to => user_id, :assigned_company => current_company_id, :category => "call", :name => message, :due_at => policy.due_date - 2.days)
        else
          current_policy_task.mark_as_completed(user_id) 
          Task.create!(current_policy_task.attributes.merge(:due_at => current_policy_task.due_at + 30.days, :deleted_at => nil))
        end
      else
        Task.create!(:asset => policy, :user_id => user_id, :assigned_to => user_id, :assigned_company => current_company_id, :category => "call", :name => "Call #{policy.customer.full_name} about renewing there policy.", :due_at => policy.due_date - 5.days)
      end
      policy.decrement!(:number_of_payments_left, 1)
    end
    
end
