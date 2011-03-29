class Order < ActiveRecord::Base
  
  belongs_to :customer, :class_name => "Customer", :foreign_key => "customer_id"
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  belongs_to :assigned_company, :class_name => "Company", :foreign_key => "assigned_company_id"
  belongs_to :parent_company, :class_name => "Company", :foreign_key => "parent_company_id"
  has_many :items
  
  scope :company, lambda { |company| {:conditions => ["assigned_company_id = ?", company.id] }}
  scope :open_order, where(:closed => false)
  scope :closed_orders, where(:closed => true)
  
  scope :with_policies, joins(:items).where("items.itemable_type = 'InsurancePolicy'")
  
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
  scope :check, where(:payment_type => "check")
  scope :credit_card, where(:payment_type => "credit_card")
  
  
  
  attr_accessible :assigned_company_id, :parent_company_id, :customer_id, :user_id, :closed, :closed_date, :payment_type, :total_cost, :total_amount, :amount_paid, :override, :customer_attributes
  
  accepts_nested_attributes_for :customer, :allow_destroy => true, :reject_if => proc { |obj| obj.blank? }
  accepts_nested_attributes_for :items, :allow_destroy => true, :reject_if => proc { |obj| obj.blank? }
  
  
  validates_presence_of :amount_paid, :on => :update, :message => "can't be blank"
  
    
    PAYMENTTYPES = %w[cash check credit_card]
    
    # totals only items that are not nested in parent_id like service groups.
    def total_price
      # convert to array so it doesn't try to do sum on database directly
      items.to_a.select{|item|item.parent_id.nil?}.sum(&:full_price)
    end
    
    # To Remove more than one Item from detection then do 
    #  something like |item|item.itemable_type == "ServiceGroup" || "whatever_else"
    def true_cost
      # convert to array so it doesn't try to do sum on database directly
      items.to_a.reject{|item|item.itemable_type == "ServiceGroup"}.sum(&:full_price)
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
      self.update_attributes(:closed => true, :closed_date => Date.today)
      self.items.each do |item|
        item.update_attributes(:closed => true, :customer_id => self.customer_id, :user_id => self.user_id)
        item.schedule_any_tasks
      end
    end
  
end
