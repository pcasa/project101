class Service < ActiveRecord::Base
  belongs_to :category, :class_name => "Category", :foreign_key => "category_id"
  has_many :special_services
  has_many :service_groups, :through => :special_services
    attr_accessible :name, :short_description, :price, :cost, :visible, :new_service, :deleted, :category_id
    accepts_nested_attributes_for :service_groups, :allow_destroy => true, :reject_if => proc { |obj| obj.blank? }
    after_update :check_if_cost_changed
    
  include ActiveModel::Dirty
  
  def check_if_cost_changed
    if self.cost_changed?
      self.service_groups.each do |sg|
        sg.save!
      end
    end
  end
    
end
