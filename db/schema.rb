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

ActiveRecord::Schema.define(:version => 20110417183727) do

  create_table "addresses", :force => true do |t|
    t.string    "street1"
    t.string    "street2"
    t.string    "city",             :limit => 64
    t.string    "state",            :limit => 64
    t.string    "zipcode",          :limit => 16
    t.timestamp "deleted_at"
    t.string    "address_type",     :limit => 32
    t.string    "addressable_type"
    t.integer   "addressable_id"
    t.boolean   "current"
    t.string    "full_address"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "addresses", ["addressable_id", "addressable_type"], :name => "index_addresses_on_addressable_id_and_addressable_type"

  create_table "admins", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string    "name"
    t.integer   "parent_id"
    t.integer   "lft"
    t.integer   "rgt"
    t.integer   "depth"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "categories", ["name", "parent_id", "lft", "rgt", "depth"], :name => "add_index_to_categories_n_pi_l_r_dpth"

  create_table "comments", :force => true do |t|
    t.text      "content"
    t.string    "commentable_type"
    t.integer   "commentable_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "comments", ["commentable_type", "commentable_id"], :name => "index_comments_on_commentable_type_and_commentable_id"

  create_table "companies", :force => true do |t|
    t.string    "name"
    t.string    "subdomain"
    t.integer   "parent_id"
    t.string    "phone_number"
    t.string    "street1"
    t.string    "street2"
    t.string    "city",         :limit => 64
    t.string    "state",        :limit => 64
    t.string    "zipcode",      :limit => 16
    t.string    "full_address"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "companies", ["name", "subdomain"], :name => "index_companies_on_name_and_subdomain"

  create_table "customers", :force => true do |t|
    t.string    "firstname"
    t.string    "lastname"
    t.string    "customer_number"
    t.string    "street1"
    t.string    "street2"
    t.string    "city",                :limit => 64
    t.string    "state",               :limit => 64
    t.string    "zipcode",             :limit => 16
    t.string    "full_address"
    t.integer   "parent_company_id"
    t.integer   "assigned_company_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "customers", ["firstname", "lastname", "customer_number", "full_address"], :name => "index_customers_on_fn_and_ln_and_cn_and_fa"
  add_index "customers", ["parent_company_id", "assigned_company_id"], :name => "index_customers_on_parent_company_id_and_assigned_company_id"

  create_table "employmentships", :force => true do |t|
    t.integer   "company_id"
    t.integer   "user_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "employmentships", ["company_id", "user_id"], :name => "index_employmentships_on_company_id_and_user_id", :unique => true
  add_index "employmentships", ["company_id"], :name => "index_employmentships_on_company_id"
  add_index "employmentships", ["user_id"], :name => "index_employmentships_on_user_id"

  create_table "endorsements", :force => true do |t|
    t.integer   "insurance_policy_id"
    t.string    "name"
    t.decimal   "previous_payment_amount"
    t.decimal   "partial_payment_amount"
    t.decimal   "new_payment_amount"
    t.decimal   "club_price"
    t.boolean   "invoiced",                :default => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "user_id"
  end

  add_index "endorsements", ["insurance_policy_id"], :name => "index_endorsements_on_insurance_policy_id"
  add_index "endorsements", ["previous_payment_amount", "partial_payment_amount", "new_payment_amount", "club_price", "invoiced"], :name => "add_index_to_endorsements_ppa_ppa_npa_cp_i"
  add_index "endorsements", ["user_id"], :name => "index_endorsements_on_user_id"

  create_table "insurance_policies", :force => true do |t|
    t.string    "policy_number",           :limit => 24
    t.boolean   "yearly",                                :default => false
    t.integer   "customer_id"
    t.integer   "vendor_id"
    t.integer   "assigned_company_id"
    t.integer   "parent_company_id"
    t.decimal   "down_payment"
    t.decimal   "club_price"
    t.decimal   "monthly_payment"
    t.date      "due_date"
    t.date      "cancelled_on"
    t.boolean   "completed",                             :default => false
    t.integer   "number_of_payments_left"
    t.integer   "parent_id"
    t.string    "policy_type",             :limit => 64
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "insurance_policies", ["due_date"], :name => "index_insurance_policies_on_due_date"
  add_index "insurance_policies", ["number_of_payments_left"], :name => "index_insurance_policies_on_number_of_payments_left"
  add_index "insurance_policies", ["parent_id"], :name => "index_insurance_policies_on_parent_id"
  add_index "insurance_policies", ["policy_number", "customer_id", "assigned_company_id", "parent_company_id", "cancelled_on", "completed", "club_price"], :name => "add_index_to_insurance_policies_pn_ci_aci_pci_c_c_cp"
  add_index "insurance_policies", ["policy_type"], :name => "index_insurance_policies_on_policy_type"

  create_table "items", :force => true do |t|
    t.string   "name",                :limit => 128
    t.string   "short_description",   :limit => 256
    t.decimal  "price"
    t.decimal  "cost"
    t.integer  "qty",                                :default => 1
    t.boolean  "visible",                            :default => true
    t.boolean  "new_service",                        :default => false
    t.boolean  "deleted",                            :default => false
    t.boolean  "closed",                             :default => false
    t.integer  "order_id"
    t.integer  "category_id"
    t.integer  "itemable_id"
    t.string   "itemable_type"
    t.integer  "vendor_id"
    t.integer  "user_id"
    t.integer  "customer_id"
    t.integer  "assigned_company_id"
    t.integer  "parent_company_id"
    t.integer  "parent_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "items", ["customer_id"], :name => "index_items_on_customer_id"
  add_index "items", ["deleted_at"], :name => "index_items_on_deleted_at"
  add_index "items", ["itemable_type", "itemable_id"], :name => "index_items_on_itemable_type_and_itemable_id"
  add_index "items", ["name", "price", "cost", "qty", "parent_id"], :name => "add_index_to_items_n_p_c_q_pi"
  add_index "items", ["new_service", "deleted", "visible", "closed"], :name => "add_index_to_items_on_ns_d_v_c"
  add_index "items", ["order_id", "vendor_id"], :name => "index_items_on_order_id_and_vendor_id"
  add_index "items", ["user_id", "assigned_company_id", "parent_company_id"], :name => "add_index_to_items_usr_assgn_comp_prnt_comp"

  create_table "orders", :force => true do |t|
    t.integer   "assigned_company_id"
    t.integer   "parent_company_id"
    t.integer   "customer_id"
    t.integer   "user_id"
    t.boolean   "closed",                            :default => false
    t.timestamp "closed_date"
    t.string    "payment_type",        :limit => 16
    t.decimal   "total_cost"
    t.decimal   "total_amount"
    t.decimal   "amount_paid"
    t.string    "override",            :limit => 6
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "orders", ["amount_paid"], :name => "index_orders_on_amount_paid"
  add_index "orders", ["assigned_company_id", "parent_company_id"], :name => "index_orders_on_assigned_company_id_and_parent_company_id"
  add_index "orders", ["closed", "closed_date"], :name => "index_orders_on_closed_and_closed_date"
  add_index "orders", ["customer_id"], :name => "index_orders_on_customer_id"
  add_index "orders", ["override"], :name => "index_orders_on_override"
  add_index "orders", ["payment_type", "total_cost", "total_amount"], :name => "index_orders_on_payment_type_and_total_cost_and_total_amount"

  create_table "phones", :force => true do |t|
    t.string    "phone_number"
    t.string    "phone_type"
    t.integer   "customer_id"
    t.boolean   "disabled",     :default => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "phones", ["customer_id", "phone_type", "disabled"], :name => "index_phones_on_customer_id_and_phone_type_and_disabled"

  create_table "services", :force => true do |t|
    t.string    "name",              :limit => 64
    t.string    "short_description", :limit => 256
    t.decimal   "price"
    t.decimal   "cost"
    t.boolean   "visible"
    t.boolean   "new_service"
    t.boolean   "deleted"
    t.boolean   "disabled"
    t.integer   "category_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "services", ["name", "short_description", "price", "cost", "visible", "new_service", "deleted", "category_id", "disabled"], :name => "add_index_to_services_n_sd_p_c_v_ns_da_ci", :unique => true

  create_table "slugs", :force => true do |t|
    t.string    "name"
    t.integer   "sluggable_id"
    t.integer   "sequence",                     :default => 1, :null => false
    t.string    "sluggable_type", :limit => 40
    t.string    "scope"
    t.timestamp "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "tasks", :force => true do |t|
    t.integer   "user_id"
    t.integer   "assigned_to"
    t.integer   "completed_by"
    t.integer   "assigned_company"
    t.string    "name",             :default => ""
    t.integer   "asset_id"
    t.string    "asset_type"
    t.string    "category"
    t.timestamp "due_at"
    t.timestamp "deleted_at"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "tasks", ["assigned_company"], :name => "index_tasks_on_assigned_company"
  add_index "tasks", ["assigned_to"], :name => "index_tasks_on_assigned_to"
  add_index "tasks", ["deleted_at"], :name => "index_tasks_on_deleted_at"
  add_index "tasks", ["user_id", "name", "deleted_at"], :name => "index_tasks_on_user_id_and_name_and_deleted_at"

  create_table "users", :force => true do |t|
    t.string    "email",                               :default => "", :null => false
    t.string    "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string    "password_salt",                       :default => "", :null => false
    t.string    "reset_password_token"
    t.string    "remember_token"
    t.timestamp "remember_created_at"
    t.integer   "sign_in_count",                       :default => 0
    t.timestamp "current_sign_in_at"
    t.timestamp "last_sign_in_at"
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "firstname",            :limit => 64
    t.string    "lastname",             :limit => 64
    t.string    "username",             :limit => 32
    t.string    "passcode",             :limit => 8
    t.string    "role",                 :limit => 16
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["passcode"], :name => "index_users_on_passcode", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["role"], :name => "index_users_on_role"

  create_table "vendors", :force => true do |t|
    t.string    "name",       :limit => 64
    t.string    "contact",    :limit => 64
    t.string    "phone",      :limit => 16
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "website"
  end

  add_index "vendors", ["name", "contact", "phone"], :name => "index_vendors_on_name_and_contact_and_phone"

end
