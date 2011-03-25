class Company < ActiveRecord::Base
  # after install run - rake friendly_id:make_slugs MODEL=company
  has_friendly_id :subdomain, :use_slug => true
  
  has_many :employmentships, :dependent => :destroy
  has_many :users, :through => :employmentships
  has_many :tasks, :as => :asset, :dependent => :destroy, :foreign_key => "assigned_company"
  
  attr_accessible :name, :parent_id, :subdomain, :address, :addresses_attributes, :address
  has_many :insurance_policies
  has_many :orders
  
  
  has_many :locations, :class_name => "Company", :foreign_key => "parent_id"
  has_many :customers
  belongs_to :parent, :class_name => "Company", :foreign_key => "parent_id"
  has_many :addresses, :class_name => "Address", :as => :addressable, :dependent => :destroy
  has_one :billing_address, :as => :addressable, :class_name => "Address", :conditions => {:address_type => 'Billing'}
  has_one :shipping_address, :as => :addressable, :class_name => "Address", :conditions => {:address_type => 'Shipping'}
  
  
  accepts_nested_attributes_for :addresses, :allow_destroy => true, :reject_if => proc { |obj| obj.blank? }
  
  # See /lib/subdomain_validator.rb for details
  validates  :subdomain, :presence   => true,
                         :uniqueness => true,
                         :subdomain  => true
                         
   def subdomain=(subdomain)
     write_attribute(:subdomain, subdomain.downcase)
   end
    
end
