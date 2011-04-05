class Phone < ActiveRecord::Base
  attr_accessible  :phone_number, :phone_type, :customer_id, :disabled
  
  belongs_to :customer, :class_name => "Customer", :foreign_key => "customer_id"
  
  PHONETYPE = %w[home work mobile]
end
