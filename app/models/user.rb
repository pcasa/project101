class User < ActiveRecord::Base
  has_many :employmentships, :dependent => :destroy
  has_many :companies, :through => :employmentships
  
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :timeoutable, :timeout_in => 200.minutes

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :firstname, :lastname, :username, :passcode, :role, :company_ids, :company_id, :companies_attributes, :employmentships_attributes
  
  accepts_nested_attributes_for :companies, :allow_destroy => true, :reject_if => proc { |obj| obj.blank? }
  
  #for seed data
  accepts_nested_attributes_for :employmentships, :allow_destroy => true, :reject_if => proc { |obj| obj.blank? }
  
  
  
  validates_uniqueness_of :username, :message => "must be unique"
  
  before_validation(:on => :create){ make_passcode }
  
  ROLES = %w[employee manager admin banned]
  
  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end
  
  def make_passcode(size = 6)
    charset = %w{ 0 1 2 3 4 5 6 7 8 0 }
    code = (0...size).map{ charset.to_a[rand(charset.size)] }.join
    self.passcode = code
  end
    
  
  
  protected

   def self.find_for_database_authentication(conditions)
     username = conditions.delete(:username)
     where(conditions).where(["username = :value", { :value => username }]).first
   end
   

   # Attempt to find a user by it's email. If a record is found, send new
   # password instructions to it. If not user is found, returns a new user
   # with an email not found error.
   def self.send_reset_password_instructions(attributes={})
     recoverable = find_recoverable_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
     recoverable.send_reset_password_instructions if recoverable.persisted?
     recoverable
   end 

   def self.find_recoverable_or_initialize_with_errors(required_attributes, attributes, error=:invalid)
     case_insensitive_keys.each { |k| attributes[k].try(:downcase!) }

     attributes = attributes.slice(*required_attributes)
     attributes.delete_if { |key, value| value.blank? }

     if attributes.size == required_attributes.size
       if attributes.has_key?(:username)
          login = attributes.delete(:username)
          record = find_record(login)
       else  
         record = where(attributes).first
       end  
     end  

     unless record
       record = new

       required_attributes.each do |key|
         value = attributes[key]
         record.send("#{key}=", value)
         record.errors.add(key, value.present? ? error : :blank)
       end  
     end  
     record
   end

   def self.find_record(username)
     where(attributes).where(["username = :value", { :value => username }]).first
   end
  
end
