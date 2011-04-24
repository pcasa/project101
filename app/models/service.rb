class Service < ActiveRecord::Base
  default_scope order("name ASC")
  belongs_to :category, :class_name => "Category", :foreign_key => "category_id"
  has_many :items, :as => :itemable
  
  
    attr_accessible :name, :short_description, :price, :cost, :visible, :new_service, :deleted, :category_id, :disabled
    
    accepts_nested_attributes_for :category, :allow_destroy => true, :reject_if => proc { |obj| obj.blank? }
    
    
    validates_presence_of :name, :short_description, :cost, :price, :category_id, :message => "can't be blank"
    
    validates_numericality_of :price, :cost, :allow_nil => true
    
  include ActiveModel::Dirty
  
  
    
end
