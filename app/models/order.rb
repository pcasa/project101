class Order < ActiveRecord::Base
  cattr_reader :per_page
    @@per_page = 25
  
  belongs_to :customer, :class_name => "Customer", :foreign_key => "customer_id"
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  belongs_to :assigned_company, :class_name => "Company", :foreign_key => "assigned_company_id"
  belongs_to :parent_company, :class_name => "Company", :foreign_key => "parent_company_id"
  has_many :items, :dependent => :destroy
  has_one :comment, :as => :commentable, :dependent => :destroy
  has_one :task, :as => :asset, :dependent => :destroy
  
  scope :company, lambda { |company| {:conditions => ["assigned_company_id = ?", company.id] }}
  scope :open_order, where(:closed => false)
  scope :closed_orders, where(:closed => true)
  
 # scope :with_policies, joins(:items).where("items.itemable_type = 'InsurancePolicy'")
  
  # Scopes for time of closed orders
  scope :closed_today, lambda { where("closed_date IS NOT ? AND closed_date >= ? AND closed_date < ?", nil, Time.now.midnight, Time.now.midnight.tomorrow)}
  scope :closed_yesterday, lambda { where("closed_date IS NOT ? AND closed_date >= ? AND closed_date < ?", nil, Time.now.midnight.yesterday, Time.now.midnight)}
  scope :closed_this_week,  lambda { where("closed_date IS NOT ? AND closed_date >= ? AND closed_date < ?", nil, Time.now.beginning_of_week , Time.now.midnight.yesterday)}
  scope :closed_last_week,  lambda { where("closed_date IS NOT ? AND closed_date >= ? AND closed_date < ?", nil, Time.now.beginning_of_week - 7.days, Time.now.beginning_of_week)}
  scope :closed_this_month, lambda { where("closed_date IS NOT ? AND closed_date >= ? AND closed_date < ?", nil, Time.now.beginning_of_month, Time.now.end_of_month)}
  scope :closed_last_month, lambda { where("closed_date IS NOT ? AND closed_date >= ? AND closed_date < ?", nil, (Time.now.beginning_of_month - 1.day).beginning_of_month, Time.now.beginning_of_month)}
  scope :closed_this_year, lambda { where("closed_date IS NOT ? AND closed_date >= ?", nil, Time.now.midnight.beginning_of_year)}
  
  
  # Scope for payment types 
  scope :cash, where(:payment_type => "cash")
  scope :credit_card, where(:payment_type => "credit_card")
  scope :other, where(:payment_type => "other")
  
  
  
  attr_accessible :assigned_company_id, :parent_company_id, :customer_id, :user_id, :closed, :closed_date, :payment_type, :total_cost, :total_amount, :amount_paid, :override, :customer_attributes, :comment_attributes, :items_attributes, :created_at, :formated_closed_date, :order_payments
  
  attr_accessor :formated_closed_date
  
  accepts_nested_attributes_for :customer, :allow_destroy => true, :reject_if => proc { |obj| obj.blank? }
  accepts_nested_attributes_for :items, :allow_destroy => true, :reject_if => proc { |obj| obj.blank? }
  accepts_nested_attributes_for :comment, :allow_destroy => true, :reject_if => lambda { |a| a[:content].blank? }
  
  
  
  validates_presence_of :amount_paid, :on => :update, :message => "can't be blank"
  
  validates_numericality_of :amount_paid, :allow_nil => true
  
    
    PAYMENTTYPES = %w[cash credit_card other]
    
    before_save :save_changes
    before_update :save_changes
    
  include ActiveModel::Dirty
  
  
  def formated_closed_date
    closed_date.strftime('%b %d, %Y %I:%M %p')
  end
  
  def formated_closed_date=(time_str)
     self.closed_date = Time.parse(time_str)
   end
  
    
    # totals only items that are not nested in parent_id like service groups.
    def total_price
      # convert to array so it doesn't try to do sum on database directly
      items.to_a.select{|item|item.parent_id.nil?}.sum(&:full_price)
    end
    
    # To Remove more than one Item from detection then do 
    #  something like |item|item.itemable_type == "ServiceGroup" || "whatever_else"
    def true_cost
      # convert to array so it doesn't try to do sum on database directly
      items.to_a.reject{|item|item.itemable_type == "ServiceGroup"}.sum(&:cost)
    end
    
    
    def amount_due
      unless amount_paid.blank?
        total_price - amount_paid
      else
        total_price
      end
    end
    
    
    
    def amount_received
      if total_price <= amount_paid
        amount_paid - (amount_paid - total_price)
      else
        amount_paid
      end
    end
    
    def close_order
      if self.closed?
        self.update_attributes(:total_cost => self.true_cost, :total_amount => self.total_price, :amount_paid => self.amount_received)
      else
        self.update_attributes(:closed => true, :closed_date => Time.now, :total_cost => self.true_cost, :total_amount => self.total_price, :amount_paid => self.amount_received)
        self.items.each do |item|
          item.update_attributes(:closed => true, :customer_id => self.customer_id, :user_id => self.user_id, :created_at => Time.now)
          item.schedule_any_tasks
        end
      end
    end
    
    
    def save_changes
      unless self.items.blank?
        if closed_date_changed? || assigned_company_id_changed? || user_id_changed? || customer_id_changed?
          self.items.each do |item|
            case
            when closed_date_changed?
              item.update_attribute(:created_at, closed_date)
            when assigned_company_id_changed?
              item.update_attribute(:assigned_company_id, self.assigned_company_id)
            when user_id_changed?
              item.update_attribute(:user_id, self.user_id)
            when customer_id_changed?
              item.update_attribute(:customer_id, self.customer_id)
            end
          end
        end
      end
    end
    
    def changed_customer(current_company)
      unless items.blank?
        customer_info = "<a href='/#{current_company.subdomain}/customers/#{self.customer_id.to_s}'>#{self.customer_id.to_s}</a>"
        items.each do |item|
          temp_desc = item.name.to_s + " - Order changed customer.  Original Customer was " + customer_info.to_s
          item.update_attributes(:name => temp_desc, :deleted_at => Time.now - 2.seconds)
        end
      end
    end
    
    #######################################################################################
    # Making a partial payment
    #######################################################################################
    def make_partial_payment(current_order, current_user_id, assigned_company_id, parent_company_id)
      Item.create!(:name => "Order Payment", :short_description => "Payment on Order ##{self.id}", :cost => self.amount_owed, :price => self.amount_owed, :qty => 1, :order_id => current_order.id, :customer_id => self.customer_id, :itemable_type => self.class, :itemable_id => self.id, :user_id => current_user_id, :assigned_company_id => assigned_company_id, :parent_company_id => parent_company_id, :category_id => Category.find_by_name("Expense").id)
      current_order.update_attribute(:customer_id, self.customer_id)
    end
    
    #######################################################################################
    # Everything about owing money to an order
    #######################################################################################
    
    # Get all order that have partial payments
    def self.with_partial_payments
       where("closed_date IS NOT NULL AND amount_paid < total_amount")
    end
    
    
    # Check if these Orders with partial payments have any payments made.
    # An open order can have only one payment
    def self.without_payments_made
      ids = self.all.collect { |order| order.id }.to_a
      items = Item.payments_on_all_orders(ids)
      return items
    end
    
    def self.without_payments_made_new
      ids = self.all.collect { |order| order.id }.to_a
      items = Item.payments_on_all_orders(ids).all.collect { |item| item.itemable_id }.to_a
      new_ids = ids - items # [1, 3, 4, 5, 7] - [1, 4, 5] will return [3, 7]
      new_orders = Order.find(new_ids)
      return new_orders
    end
    
    
    # Example of how to use above
    # Order.with_partial_payments.without_payments_made
    # Will return all orders that don't have a payment in one sql call
    
    def amount_owed
      total_price - amount_paid
    end
    
    def is_a_partial_payment
      amount_paid < total_price
    end
    
    # used to see if a particular order has a payment
    def partial_payments_made
      item = Item.order_payments(self).first
      return item
    end
    
    def still_owes
      unless partial_payments_made.blank?
        if amount_owed <= partial_payments_made.full_price
          return false
        else
          return true
        end
      else
        return true
      end
    end
    
    
    def clear_order_task(original_order, user_id)
      msg = " - System Note - Made payment on Order ##{original_order}."
      unless original_order.task.blank?
        original_order.task.mark_completed_and_msg(user_id, msg)
      end
    end
  
end
