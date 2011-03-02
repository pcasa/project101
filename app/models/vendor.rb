class Vendor < ActiveRecord::Base
    attr_accessible :name, :contact, :phone, :addresses_attributes, :address
    has_many :insurance_policies
    
    has_many :addresses, :as => :addressable
    accepts_nested_attributes_for :addresses, :allow_destroy => true, :reject_if => proc { |obj| obj.blank? }
end
