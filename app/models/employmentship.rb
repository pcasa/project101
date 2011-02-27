class Employmentship < ActiveRecord::Base
  belongs_to :company
  belongs_to :user
 # attr_accessor :company_id, :user_id
end
