Project101::Application.routes.draw do

  match '/companies' => 'companies#index'
  match '/:company_id/companies' => 'companies#index', :as => :index_company
  match '/:company_id' => 'companies#show', :as => :show_company
  match '/companies/:id/edit' => 'companies#edit', :as => :edit_company
  match '/companies/:id/new' => 'companies#new', :as => :new_company
  match '/companies/:id/destroy' => 'companies#destroy', :as => :delete_company  
  match '/:company_id/dashboard' => 'companies#dashboard', :as => :company_dashboard
  match "/:company_id/customers/my_customers" => "customers#my_customers", :as => :my_customers 
  
  match '/users/dashboard' => 'users#dashboard', :as => :users_dashboard
    
  match '/:company_id/users/:id/verify_current_user' => 'users#verify_current_user', :as => :verify_user
  
  scope '/:company_id', :as => :company do 
    match '/orders/all_services_popup' => 'orders#all_services_popup', :as => :all_services_popup
    match '/orders/:id/print_order' => 'orders#print_order', :as => :print_order
    match '/services/:id/add_to_order' => 'services#add_to_order', :as => :add_service_to_order
    match '/customers/:customer_id/customer_orders' => 'customers#customer_orders', :as => :customer_orders
    match '/customers/:customer_id/customer_policies' => 'customers#customer_policies', :as => :customer_policies
    match '/customers/:customer_id/customer_addresses' => 'customers#customer_addresses', :as => :customer_addresses
    match '/customers/:customer_id/customer_comments' => 'customers#customer_comments', :as => :customer_comments
    
    match '/insurance_policies/:id/add_policy_payment' => 'insurance_policies#add_policy_payment', :as => :policy_payment
    match '/insurance_policies/:id/cancel_policy' => 'insurance_policies#cancel_policy', :as => :policy_cancel
    match '/admins/item_really_destroy/:item_id/' => 'admins#item_really_destroy', :as => :item_really_destroy
    get '/admins/' => 'admins#index'
    get '/admins/deleted_items' => 'admins#deleted_items', :as => :deleted_items
    
    resources :items
    resources :users do
      resources :tasks
    end
    resources :insurance_policies do
      resources :tasks
    end
    
    resources :orders do
      resources :items
      resources :comments
    end
    resources :categories
    resources :addresses
    resources :services
    resources :customers do 
      resources :tasks
      resources :insurance_policies
      resources :addresses
      resources :items
      resources :comments
      resources :phones
    end
    
    resources :vendors do 
      resources :insurance_policies
      resources :addresses
    end
    
    resources :comments
    
    resources :tasks
    get '/reports' => 'reports#index', :as => :reports
    get '/reports/store_reports' => 'reports#store_reports', :as => :store_reports
    get '/reports/policy_reports' => 'reports#policy_reports', :as => :policy_reports
    get '/reports/full_reports' => 'reports#full_reports', :as => :full_reports
    match '/reports/policy_reports/render_my_partial' => 'reports#render_my_partial', :as => :render_my_partial
  end
  
  resources :companies
  
   
  

  devise_for :users
  resources :users, :controller => "users"
  resources :homes
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  
  
  root :to => "companies#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
