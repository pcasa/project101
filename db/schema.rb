# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110226144805) do

  create_table "addresses", :force => true do |t|
    t.string   "street1"
    t.string   "street2"
    t.string   "city",             :limit => 64
    t.string   "state",            :limit => 64
    t.string   "zipcode",          :limit => 16
    t.datetime "deleted_at"
    t.string   "address_type",     :limit => 32
    t.string   "addressable_type"
    t.integer  "addressable_id"
    t.boolean  "current"
    t.string   "full_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["addressable_id", "addressable_type"], :name => "index_addresses_on_addressable_id_and_addressable_type"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["name", "parent_id"], :name => "index_categories_on_name_and_parent_id"

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subdomain"
  end

  add_index "companies", ["subdomain"], :name => "index_companies_on_subdomain"

  create_table "customers", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "customer_number"
    t.string   "street1"
    t.string   "street2"
    t.string   "city",                :limit => 64
    t.string   "state",               :limit => 64
    t.string   "zipcode",             :limit => 16
    t.string   "full_address"
    t.integer  "parent_company_id"
    t.integer  "assigned_company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customers", ["firstname", "lastname", "customer_number", "full_address"], :name => "index_customers_on_fn_and_ln_and_cn_and_fa"
  add_index "customers", ["parent_company_id", "assigned_company_id"], :name => "index_customers_on_parent_company_id_and_assigned_company_id"

  create_table "employmentships", :force => true do |t|
    t.integer  "company_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "employmentships", ["company_id", "user_id"], :name => "index_employmentships_on_company_id_and_user_id", :unique => true
  add_index "employmentships", ["company_id"], :name => "index_employmentships_on_company_id"
  add_index "employmentships", ["user_id"], :name => "index_employmentships_on_user_id"

  create_table "service_groups", :force => true do |t|
    t.string   "name",              :limit => 64
    t.string   "short_description", :limit => 256
    t.decimal  "cost",                             :precision => 12, :scale => 2
    t.decimal  "price",                            :precision => 12, :scale => 2
    t.boolean  "new_service"
    t.boolean  "deleted"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "service_groups", ["name", "short_description", "price", "cost", "new_service", "deleted", "category_id"], :name => "add_index_to_service_groups_n_sd_p_c_ns_da_ci", :unique => true

  create_table "services", :force => true do |t|
    t.string   "name",              :limit => 64
    t.string   "short_description", :limit => 256
    t.decimal  "price",                            :precision => 12, :scale => 2
    t.decimal  "cost",                             :precision => 12, :scale => 2
    t.boolean  "visible"
    t.boolean  "new_service"
    t.boolean  "deleted"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "services", ["name", "short_description", "price", "cost", "visible", "new_service", "deleted", "category_id"], :name => "add_index_to_services_n_sd_p_c_v_ns_da_ci", :unique => true

  create_table "special_services", :force => true do |t|
    t.integer  "service_id"
    t.integer  "service_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "special_services", ["service_id", "service_group_id"], :name => "add_index_to_special_services_si_sgi", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "firstname",            :limit => 64
    t.string   "lastname",             :limit => 64
    t.string   "username",             :limit => 32
    t.string   "passcode",             :limit => 8
    t.string   "role",                 :limit => 16
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["passcode"], :name => "index_users_on_passcode", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["role"], :name => "index_users_on_role"

  create_table "vendors", :force => true do |t|
    t.string   "name",       :limit => 64
    t.string   "contact",    :limit => 64
    t.string   "phone",      :limit => 16
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vendors", ["name", "contact", "phone"], :name => "index_vendors_on_name_and_contact_and_phone", :unique => true

end
