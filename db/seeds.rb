# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

require 'faker'

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

c_company = Company.new do |p| 
  p.id = 3
  p.name = 'Douglasville'
  p.subdomain = 'douglassville'
  p.parent_id = 1
  p.save
end

d_company = Company.new do |p| 
  p.id = 4
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
