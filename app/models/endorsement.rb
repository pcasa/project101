class Endorsement < ActiveRecord::Base
  
  belongs_to :insurance_policy, :class_name => "InsurancePolicy", :foreign_key => "insurance_policy_id"
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  
  has_many :items, :as => :itemable
  
  scope :valid_endorsement, where(:invoiced => true)
  
    attr_accessible :insurance_policy_id, :name, :previous_payment_amount, :partial_payment_amount, :new_payment_amount, :club_price, :invoiced, :user_id
    
    attr_accessor :valid_endorsement, :partial_payment
    
    validates_numericality_of :partial_payment_amount, :new_payment_amount, :message => "is not a number", :allow_nil => true
    validates_presence_of :name, :new_payment_amount, :message => "can't be blank"
    
    
    
    def partial_payment?
      !partial_payment_amount.blank?
    end
    
    
    def get_previous_amount(policy)
      if policy.endorsements.valid_endorsement.blank?
        previous_amount = policy.monthly_payment
      else
        previous_amount = policy.endorsements.valid_endorsement.first.new_payment_amount
      end
      return previous_amount
    end
    
    
    def add_to_order(policy, current_order, user_id, company_id, parent_company_id)
      if partial_payment?
        payments_left = policy.number_of_payments_left
        next_due_date = policy.due_date
        item_name = "Endorsement Payment"
        desc = self.name + ".  Endorsement payment only, on policy " + policy.item_description(payments_left, next_due_date)
        cost = self.partial_payment_amount
        if !self.club_price.blank?
          price = self.partial_payment_amount + self.club_price
        else
          price = self.partial_payment_amount
        end
      else
        payments_left = policy.number_of_payments_left - 1
        next_due_date = policy.due_date.next_month
        item_name = "Endorsement and Policy Payment"
        desc = self.name + ".  Endorsement and Policy payment on policy " + policy.item_description(payments_left, next_due_date)
        cost = self.new_payment_amount
        if !self.club_price.blank?
          price = self.new_payment_amount + self.club_price
        else
          price = self.new_payment_amount
        end
      end
       current_order.update_attribute(:customer_id, policy.customer_id)
       Item.create!(:name => item_name, :short_description => desc, :visible => true, :new_service => !self.partial_payment, :itemable => policy, :user_id => user_id, :customer_id => policy.customer_id, :order_id => current_order.id, :parent_company_id => parent_company_id, :assigned_company_id => company_id, :cost => cost, :price => price, :qty => 1, :category_id => Category.find_by_name("Insurance Policy").id, :vendor_id => policy.vendor_id) 
    end
    
    
     
   
end
