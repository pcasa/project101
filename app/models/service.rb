class Service < ActiveRecord::Base
  
  belongs_to :category, :class_name => "Category", :foreign_key => "category_id"
  has_many :special_services
  has_many :service_groups, :through => :special_services
  has_many :items, :as => :itemable
  
  
    attr_accessible :name, :short_description, :price, :cost, :visible, :new_service, :deleted, :category_id, :disabled
    accepts_nested_attributes_for :service_groups, :allow_destroy => true, :reject_if => proc { |obj| obj.blank? }
    after_update :check_if_cost_changed
    
    validates_presence_of :name, :short_description, :cost, :price, :category_id, :message => "can't be blank"
    
    validates_numericality_of :price, :cost, :allow_nil => true
    
  include ActiveModel::Dirty
  
  def check_if_cost_changed
    if self.cost_changed?
      self.service_groups.each do |sg|
        sg.save!
      end
    end
  end
    
end
