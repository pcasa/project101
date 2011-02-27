class Category < ActiveRecord::Base
  has_many :services
  has_many :service_groups
  has_many :children, :class_name => "Category", :foreign_key => "parent_id"
  
    attr_accessible :name, :parent_id
   # validates_presence_of :parent_id, :message => "must be selected!"
    
    
    
    def name=(name)
       write_attribute(:name, name.slice(0,1).capitalize + name.slice(1..-1))
    end
    
end
