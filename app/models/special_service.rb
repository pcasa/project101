class SpecialService < ActiveRecord::Base
  belongs_to :service, :class_name => "Service", :foreign_key => "service_id"
  belongs_to :service_group, :class_name => "ServiceGroup", :foreign_key => "service_group_id"
    attr_accessible :service_id, :service_group_id
    
end
