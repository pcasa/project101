class Address < ActiveRecord::Base
    attr_accessible :street1, :street2, :city, :state, :zipcode, :deleted_at, :addressable_type, :addressable_id, :current, :full_address, :address_type
    belongs_to :addressable, :polymorphic => true
    
    scope :customer, where("address_type='Customer'")
    scope :business, where("address_type='Business'")
    scope :billing, where("address_type='Billing'")
    scope :vendor, where("address_type='Vendor'")
    
    before_save :update_full_address
    
    
    def update_full_address
      unless self.street2.blank?
        street = self.street1 + "<br />" + self.street2 + "<br />" 
      else 
        street = self.street1 + "<br />"
      end
      citystatezip = self.city + ", " + self.state + " " + self.zipcode
      self.full_address = street + citystatezip
    end
    
    
end
