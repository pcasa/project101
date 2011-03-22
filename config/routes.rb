Project101::Application.routes.draw do

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
    match '/services/:id/add_to_order' => 'services#add_to_order', :as => :add_service_to_order
    match '/service_groups/:id/add_to_order' => 'service_groups#add_to_order', :as => :add_service_groups_to_order
    match '/customers/:customer_id/customer_orders' => 'customers#customer_orders', :as => :customer_orders
    match '/customers/:customer_id/customer_policies' => 'customers#customer_policies', :as => :customer_policies
    match '/customers/:customer_id/customer_addresses' => 'customers#customer_addresses', :as => :customer_addresses
    resources :items
    resources :users 
    resources :insurance_policies
    
    resources :orders do
      resources :items
    end
    resources :categories
    resources :addresses
    resources :services
    resources :special_services
    resources :service_groups
    resources :customers do 
      
      resources :insurance_policies
      resources :addresses
      resources :items
    end
    
    resources :vendors do 
      resources :insurance_policies
      resources :addresses
    end
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
