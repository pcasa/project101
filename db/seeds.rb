# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

require 'faker'
require 'populator'





puts "Clearing Addresses"
Address.delete_all

puts "Clearing Tasks"
Task.delete_all!

puts "Clearing Orders"
Order.delete_all

puts "Clearing Items"
Item.delete_all!

puts "Clearing Insurance Policies"
InsurancePolicy.delete_all

puts "Clearing Notes"
Comment.delete_all

puts "Clearing Phones"
Phone.delete_all

puts "Clearing Customers"
Customer.delete_all


puts "Adding Vendors"
Vendor.delete_all
["Progressive", "Asurance America", "United Auto", "Infinity", "Georgia Mutual"].each do |c|
  params = {:vendor => 
      {
        :name => c,
        :contact => Faker::Name.name,
        :phone => Faker::PhoneNumber.phone_number[0, 16],
        :addresses_attributes => [{
          :street1 => Faker::Address.street_address,
          :city => Faker::Address.city,
          :state => Faker::Address.us_state_abbr,
          :zipcode => Faker::Address.zip_code,
          :address_type => "Vendor"
          }]
      }
    } 
  Vendor.create!(params[:vendor]) 
end

puts "Adding Categories"
Category.delete_all
# Have to do manually for force ID
a_category = Category.new do |c|
  c.id = 1
  c.name = "Income"
  c.save
end

b_category = Category.new do |c|
  c.id = 2
  c.name = "Expense"
  c.save
end

c_category = Category.new do |c|
  c.id = 3
  c.name = "Insurance Policy"
  c.parent_id = 2
  c.save
end

d_category = Category.new do |c|
  c.id = 4
  c.name = "Profit"
  c.parent_id = 1 
  c.save
end

e_category = Category.new do |c|
  c.id = 5
  c.name = "Runner Fees"
  c.parent_id = 2 
  c.save
end

e_category = Category.new do |c|
  c.id = 6
  c.name = "Credit Card Processing Fees"
  c.parent_id = 2 
  c.save
end

e_category = Category.new do |c|
  c.id = 7
  c.name = "Invoiced Partial Payments"
  c.parent_id = 2 
  c.save
end




puts"Adding Companies"
Company.delete_all
# Have to do manually for force ID
a_company = Company.new do |p| 
  p.id = 1
  p.name = '101 Insurance'
  p.subdomain = '101insurance'
  p.save
end

b_company = Company.new do |p| 
  p.id = 2
  p.name = 'Norcross'
  p.subdomain = 'norcross'
  p.parent_id = 1
  p.save
end

d_company = Company.new do |p| 
  p.id = 3
  p.name = 'Cumming'
  p.subdomain = 'Commin'
  p.parent_id = 1
  p.save
end

puts "Clearing Services"

Service.delete_all

puts "Adding Services"


Service.create!(:name => "Tag & Title", :short_description => "Tag & Title Services", :price => 140, :cost => 40, :category_id => 5, :new_service => true, :deleted => false, :visible => true)
Service.create!(:name => "Title", :short_description => "Title Services", :price => 88, :cost => 48, :category_id => 5, :new_service => true, :deleted => false, :visible => true)
Service.create!(:name => "Tag", :short_description => "Tag Services", :price => 140, :cost => 40, :category_id => 5, :new_service => true, :deleted => false, :visible => true)
Service.create!(:name => "Special Tag", :short_description => "Special Tag Services", :price => 225, :cost => 125, :category_id => 5, :new_service => true, :deleted => false, :visible => true)
Service.create!(:name => "Tag Renewal", :short_description => "Tag Renewal Services", :price => 50, :cost => 20, :category_id => 5, :new_service => true, :deleted => false, :visible => true)
Service.create!(:name => "Salvage Title", :short_description => "Salvage Title Services", :price => 370, :cost => 370, :category_id => 5, :new_service => true, :deleted => false, :visible => true)
Service.create!(:name => "Title Bond", :short_description => "Title Bond Services", :price => 140, :cost => 40, :category_id => 5, :new_service => true, :deleted => false, :visible => true)
Service.create!(:name => "Tag Transfer", :short_description => "Tag Transfer", :price => 120, :cost => 90, :category_id => 2, :new_service => false, :deleted => false, :visible => true)
Service.create!(:name => "Affidavit Correction", :short_description => "Affidavit Correction", :price => 30, :cost => 30, :category_id => 2, :new_service => false, :deleted => false, :visible => true)
Service.create!(:name => "Policy Fee", :short_description => "Policy Fee", :price => 1, :cost => 1, :category_id => 3, :new_service => false, :deleted => false, :visible => true)
Service.create!(:name => "Convenience Fee", :short_description => "Convenience Fee", :price => 5, :cost => 5, :category_id => 6, :new_service => false, :deleted => false, :visible => true)
Service.create!(:name => "Progressive Policy Fee", :short_description => "Progressive Policy Fee", :price => 1, :cost => 1, :category_id => 3, :new_service => false, :deleted => false, :visible => true)





puts "Deleting Users and Employmentships in Companies"
User.delete_all
Employmentship.delete_all


puts "Adding Users..."
["admin", "manager", "employee"].each do |user|  
  User.create!(:firstname => user,
  :lastname => user,
  :email => user + "@" + user + ".com",
  :username => user,
  :password => "123456",
  :password_confirmation => "123456",
  :passcode =>  user.upcase + "12345"[0,8],
  :role => user,
  :employmentships_attributes => [{:company_id => 1}]) 
end

User.create!(:firstname => 'LALO',
:lastname => 'LALO',
:email => 'LALO' + "@" + 'LALO' + ".com",
:username => 'LALO',
:password => "QWERTY",
:password_confirmation => "QWERTY",
:passcode =>  'LALO'.upcase + "12345"[0,8],
:role => 'admin',
:employmentships_attributes => [{:company_id => 1}])

User.create!(:firstname => 'MARLENLE',
:lastname => 'MARLENLE',
:email => 'MARLENLE' + "@" + 'MARLENLE' + ".com",
:username => 'MARLENLE',
:password => "QWERTY",
:password_confirmation => "QWERTY",
:passcode =>  'MARLENLE'.upcase + "12345"[0,8],
:role => 'employee',
:employmentships_attributes => [{:company_id => 2}])

User.create!(:firstname => 'JULIANA',
:lastname => 'JULIANA',
:email => 'JULIANA' + "@" + 'JULIANA' + ".com",
:username => 'JULIANA',
:password => "QWERTY",
:password_confirmation => "QWERTY",
:passcode =>  'JULIANA'.upcase + "12345"[0,8],
:role => 'employee',
:employmentships_attributes => [{:company_id => 3}])


#   puts "Adding Customers and Orders..."
#   Company.all.each do |company|
#     Customer.populate(50..200) do |person|
#         person.parent_company_id = company.id
#         person.assigned_company_id = 1
#         street1 = Faker::Address.street_address(include_secondary = false)
#         city = Faker::Address.city
#         state = Faker::Address.state_abbr
#         zip = Faker::Address.zip
#         person.firstname = Faker::Name.first_name
#         person.lastname = Faker::Name.last_name
#         person.street1 = street1
#         person.city = city
#         person.state = state
#         person.zipcode = zip
#         person.full_address = street1 + "<br />" + city + ", " + state + " " + zip
#         person.customer_number = 11111111..99999999
#         Order.populate(0..3) do |order|
#           date = (rand*10).days.ago
#           order.customer_id = person.id
#           offset = rand(Service.count)
#           @service = Service.first(:offset => offset)
#           user_offset = rand(User.count)
#           @user = User.first(:offset => user_offset)
#           Item.create!(@service.attributes.merge(:items => @service.items, :order_id => order.id, :itemable => @service, :qty => 1, :visible => true, :assigned_company_id => company.id, :parent_company_id => 1, :user_id => @user.id, :closed => true, :created_at => date, :customer_id => person.id))
#           order.user_id = @user.id
#           order.closed = true
#           order.payment_type = "cash"
#           order.created_at = date
#           order.closed_date = date
#           order.assigned_company_id = company.id
#           order.parent_company_id = 1
#           order.total_amount = @service.price
#           order.amount_paid = @service.price
#           order.total_cost = @service.cost
#         end
#       end
#   end
