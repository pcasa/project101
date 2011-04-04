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
  p.subdomain = 'Comming'
  p.parent_id = 1
  p.save
end

puts "Clearing Services, Service Groups and Special Services"
SpecialService.delete_all
ServiceGroup.delete_all
Service.delete_all

puts "Adding Services"
["Title", "Tag", "Runner"].each do |s|
  Service.create!(:name => s, :short_description => "Short description for #{s}", :price => 10, :cost => 5, :category_id => 1, :new_service => false, :deleted => false, :visible => true) 
end





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
