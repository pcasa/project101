class Order < ActiveRecord::Base
  
  belongs_to :customer, :class_name => "Customer", :foreign_key => "customer_id"
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  belongs_to :assigned_company, :class_name => "Company", :foreign_key => "assigned_company_id"
  belongs_to :parent_company, :class_name => "Company", :foreign_key => "parent_company_id"
  has_many :items
  
  scope :company, lambda { |company| {:conditions => ["assigned_company_id = ?", company.id] }}
  scope :open_order, where(:closed => false)
  
  
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
  
end
