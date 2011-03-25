class Customer < ActiveRecord::Base
  
  default_scope order('lastname, firstname')
  
  belongs_to :company, :class_name => "Company", :foreign_key => :parent_company_id
  attr_accessible :firstname, :lastname, :customer_number, :parent_company_id, :assigned_company_id, :street1, :street2, :city, :state, :zipcode, :full_address, :addresses_attributes, :search, :full_name
  has_many :addresses, :class_name => "Address", :as => :addressable
  has_many :insurance_policies, :class_name => "InsurancePolicy"
  has_many :orders
  has_many :items
  has_many :tasks, :as => :asset, :dependent => :destroy
  
  accepts_nested_attributes_for :addresses, :allow_destroy => true, :reject_if => proc { |obj| obj.blank? }
  
  
  before_validation(:on => :create){ make_customer_number }
  validates_presence_of :firstname, :lastname, :street1, :city, :state, :zipcode, :message => "can't be blank"
  before_save :update_full_address
  before_update :check_if_address_changed
  
  
  include ActiveModel::Dirty

  
  
  def make_customer_number(size = 8)
    charset = %w{ 2 3 4 6 7 9 A C D E F G H J K L M N P Q R T V W X Y Z}
    code = (0...size).map{ charset.to_a[rand(charset.size)] }.join
    self.customer_number = code
  end
  
  def update_full_address
    unless self.street2.blank?
      street = self.street1 + "<br />" + self.street2 + "<br />" 
    else 
      street = self.street1 + "<br />"
    end
    citystatezip = self.city + ", " + self.state + " " + self.zipcode
    self.full_address = street + citystatezip
  end
  
  def full_name
    self.firstname + " " + self.lastname
  end
  
  
  
  def check_if_address_changed
    if self.street1_changed? || self.street2_changed? || self.city_changed? || self.state_changed? || self.zipcode_changed?
      Address.create!(:street1 => self.street1_was, :street2 => self.street2_was, :city => self.city_was, :state => self.state_was, :zipcode => self.zipcode_was, :addressable_type => "Customer", :addressable_id => self.id, :full_address => self.full_address, :address_type => "Customer")
    end
  end
  

end
