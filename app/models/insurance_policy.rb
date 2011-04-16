class InsurancePolicy < ActiveRecord::Base
  
    attr_accessible :policy_number, :yearly, :customer_id, :vendor_id, :assigned_company_id, :parent_company_id, :due_date, :cancelled_on, :completed, :number_of_payments_left, :parent_id, :policy_type, :down_payment, :monthly_payment, :club_price, :created_at
    
    attr_accessor :current_monthly_amount
    
    belongs_to :customer, :class_name => "Customer", :foreign_key => "customer_id"
    belongs_to :vendor, :class_name => "Vendor", :foreign_key => "vendor_id"
    has_one :child, :class_name => "InsurancePolicy", :foreign_key => "parent_id"
    belongs_to :parent, :class_name => "InsurancePolicy"
    belongs_to :assigned_company, :class_name => "Company", :foreign_key => "assigned_company_id"
    belongs_to :parent_company, :class_name => "Company", :foreign_key => "parent_company_id"
    has_many :items, :as => :itemable
    has_many :tasks, :as => :asset, :dependent => :destroy
    has_many :comments, :as => :commentable
    has_many :endorsements, :dependent => :destroy
    
    scope :new_policies, where("policy_type='New'")
    scope :renewal, where("policy_type='Renewal'")
    scope :reinstated, where("policy_type='Reinstate'")
    
    scope :with_comments, :joins => :comments, 
                                  :order => "comments.created_at DESC"
    
    validates_presence_of :policy_number, :customer_id, :vendor_id, :due_date, :number_of_payments_left, :policy_type, :down_payment, :monthly_payment, :club_price, :message => "can't be blank"
    
    validates_numericality_of :number_of_payments_left, :down_payment, :monthly_payment, :allow_nil => true
    
    POLICYTYPE = %w[New Renewal Reinstate Existing]
    
    def cancelled?
      !self.cancelled_on.blank?
    end
    
    def current_monthly_amount
      if endorsements.valid_endorsement.blank?
        current_amount = self.monthly_payment
      else
        current_amount = endorsements.valid_endorsement.first.new_payment_amount
      end
      return current_amount
    end
    
    def renewal_date
      if yearly?
        rd = self.created_at.next_year
      else
        rd = self.created_at + 6.months
      end
      return rd
    end
    
    
    def item_description(payments_left, next_due_date)
      temp_desc1 = "#" + self.policy_number + " from " + self.vendor.name + ".  "
      if payments_left > 1
        temp_desc2 = "You have " + payments_left.to_s + " payments left.  Your next payment is on #{next_due_date.strftime('%b %d, %Y')}."
      elsif payments_left == 0
        temp_desc2 = "This is your last payment.  If you have any questions about your renewal, please feel free to ask us.  Your Renewal is on #{self.renewal_date.strftime('%b %d, %Y')}."
      else
        temp_desc2 = "You have " + payments_left.to_s + " payment left. Your next payment is on #{next_due_date.strftime('%b %d, %Y')}.  Your renewal is comming up."
      end
      return temp_desc1 + temp_desc2
    end
    
    
    
    def add_new_payment(current_order, user_id, assigned_company, parent_company_id, true_or_false)
      # remove one payment since customer is making one now
      payments_left = self.number_of_payments_left - 1
      # Get next date based on if DownPayment or actuall Policy Payment
      if self.items.blank?
        next_due_date = self.due_date
      else
        next_due_date = self.due_date.next_month
      end
      
      if !self.items.valid_items.blank? || self.policy_type == "Existing"
        payment_amount = self.current_monthly_amount 
        sale_price = self.current_monthly_amount + 2.00
        temp_desc3 = "  Includes $2.00 processing fee."
      else 
        payment_amount = self.down_payment 
        sale_price = payment_amount + club_price
        temp_desc3 = ""
      end
      full_desc = "Payment on policy " + self.item_description(payments_left, next_due_date) + temp_desc3
      current_order.update_attribute(:customer_id, self.customer_id)
      Item.create!(:name => "Policy Payment", :short_description => full_desc, :visible => true, :new_service => true_or_false, :itemable => self, :user_id => user_id, :customer_id => self.customer_id, :order_id => current_order.id, :parent_company_id => parent_company_id, :assigned_company_id => assigned_company.id, :cost => payment_amount, :price => sale_price, :qty => 1, :category_id => Category.find_by_name("Insurance Policy").id, :vendor_id => self.vendor_id)      
    end
    
    
    
    
    def schedule_policy_task(policy, user_id, current_company_id, item)
      # First we update policy due_date if not Down Payment
      unless policy.items.blank? || (policy.items.count == 1) || !policy.policy_type == "Existing" || item.name == "Endorsement Payment"
        new_due_date = policy.due_date.next_month
        policy.update_attribute(:due_date, new_due_date)
      end
      # Check to see if any tasks associated with Parent Policy
      # if so we clear them all.  Also update parent to mark as completed
      if (policy.items.count == 1) && !policy.parent_id.blank?
        if policy.policy_type == "Renewal"
          policy.parent.update_attribute(:completed, true) if !policy.parent.completed?
          unless policy.parent.tasks.pending.blank?
           policy.parent.tasks.pending.each do |p|
             msg = "System Note - Renewed the policy with another one."
             p.mark_completed_and_msg(user_id, msg)
           end
         end
        end
      end
      if (item.name == "Endorsement Payment") || (item.name == "Endorsement and Policy Payment")
        unless policy.endorsements.first.invoiced?
          policy.endorsements.first.update_attribute(:invoiced, true)
        end
      end
      if item.name != "Endorsement Payment"
        message = "Call " + policy.customer.full_name + " to remind them about there payment."
        current_policy_task = policy.tasks.last
        if policy.number_of_payments_left > 1
          if current_policy_task.blank?
            Task.create!(:asset_type => policy.class, :asset_id => policy.id, :user_id => user_id, :assigned_company => policy.assigned_company_id, :category => "call", :name => message, :due_at => policy.due_date - 2.days)
          else
            Task.create!(current_policy_task.attributes.merge(:due_at => policy.due_date - 2.days, :deleted_at => nil))
          end
        else
          Task.create!(:asset_type => policy.class, :asset_id => policy.id, :user_id => user_id, :assigned_company => policy.assigned_company_id, :category => "call", :name => "Call #{policy.customer.full_name} about renewing there policy.", :due_at => policy.due_date - 5.days) 
        end
        if !current_policy_task.blank?
          if !current_policy_task.comment.blank? && !current_policy_task.comment.content.blank?
            msg = current_policy_task.comment.content.to_s + " - I am line item 124 System Note - Made a policy payment."
          else
            msg = "I am line item 126 - System Note - Made a policy payment."
          end
          current_policy_task.mark_completed_and_msg(user_id, msg)
        end 
        policy.decrement!(:number_of_payments_left, 1) 
      end
    end
    
    
    
end
