class Order < ActiveRecord::Base
  cattr_reader :per_page
    @@per_page = 25
  
  belongs_to :customer, :class_name => "Customer", :foreign_key => "customer_id"
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  belongs_to :assigned_company, :class_name => "Company", :foreign_key => "assigned_company_id"
  belongs_to :parent_company, :class_name => "Company", :foreign_key => "parent_company_id"
  has_many :items, :dependent => :destroy
  has_one :comment, :as => :commentable
  
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
  scope :credit_card, where(:payment_type => "credit_card")
  scope :other, where(:payment_type => "other")
  
  
  
  attr_accessible :assigned_company_id, :parent_company_id, :customer_id, :user_id, :closed, :closed_date, :payment_type, :total_cost, :total_amount, :amount_paid, :override, :customer_attributes, :comment_attributes, :items_attributes, :created_at, :formated_closed_date
  
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
      if closed_date_changed? || assigned_company_id_changed?
        self.items.each do |item|
          if closed_date_changed?
            item.update_attribute(:created_at, closed_date)
          end
          if assigned_company_id_changed?
            item.update_attribute(:assigned_company_id, self.assigned_company_id)
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
  
end
