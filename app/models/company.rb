class Company < ActiveRecord::Base
  # after install run - rake friendly_id:make_slugs MODEL=company
  has_friendly_id :subdomain, :use_slug => true
  
  has_many :employmentships, :dependent => :destroy
  has_many :users, :through => :employmentships
  has_many :tasks, :as => :asset, :dependent => :destroy, :foreign_key => "assigned_company"
  
  attr_accessible :name, :parent_id, :subdomain, :address, :address_attributes, :phone_number,:street1, :street2, :city, :state, :zipcode, :full_address
  
  
  has_many :insurance_policies
  has_many :orders
  
  
  has_many :locations, :class_name => "Company", :foreign_key => "parent_id"
  has_many :customers
  belongs_to :parent, :class_name => "Company", :foreign_key => "parent_id"
  
  
  
  # See /lib/subdomain_validator.rb for details
  validates  :subdomain, :presence   => true,
                         :uniqueness => true,
                         :subdomain  => true
                         
  before_save :update_full_address 


  def update_full_address
    unless self.street1.blank?
     unless self.street2.blank?
       street = self.street1 + "<br />" + self.street2 + "<br />" 
     else 
       street = self.street1 + "<br />"
     end
     citystatezip = self.city + ", " + self.state + " " + self.zipcode
     self.full_address = street + citystatezip
   end
  end
                         
   def subdomain=(subdomain)
     write_attribute(:subdomain, subdomain.downcase)
   end
    
end
