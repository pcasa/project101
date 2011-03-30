class ServiceGroup < ActiveRecord::Base
  belongs_to :category, :class_name => "Category", :foreign_key => "category_id"
  has_many :special_services, :dependent => :destroy
  has_many :services, :through => :special_services
  has_many :items, :as => :itemable
  validates_numericality_of :price
  
    attr_accessible :name, :short_description, :cost, :price, :new_service, :deleted, :category_id, :service_ids
    
    accepts_nested_attributes_for :services, :allow_destroy => true, :reject_if => proc { |obj| obj.blank? }
    accepts_nested_attributes_for :special_services, :allow_destroy => true, :reject_if => proc { |obj| obj.blank? }
    before_save :update_cost
    
    validates_presence_of :name, :short_description, :price, :category_id, :message => "can't be blank"
    validate :check_services
    
    def update_cost
      totalup = self.services.map{|service| service.cost}.sum
      self.cost = totalup
    end
    
    
    
    def check_services
      if self.services.size < 1 || self.services.all?{|service| service.marked_for_destruction? }
        errors.add(:services, "You must choose at least one service.")
      end
    end
    
end
