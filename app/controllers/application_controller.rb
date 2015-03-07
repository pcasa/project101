class ApplicationController < ActionController::Base
  include UrlHelper
  # protect_from_forgery  # temp disable till Jquery UJS updated
  protect_from_forgery :except => [:destory, :update, :delete, :create]
  helper_method :current_company, :main_company, :is_employed_at?, :current_order, :current_tasks
  
  before_filter :user_belongs_to_company
  
  
  
  
  
  def current_company
    if params[:company_id] != nil || params[:company_id] == 'companies'
      @current_company ||= Company.find(params[:company_id])
    else
      @current_company = nil
    end
    return @current_company
  end
  
  def main_company
    if current_company.parent_id == nil
      @main_company = current_company
    else
      @main_company = current_company.parent
    end
  end
  
  def is_employed_at?(user, company)
    employed = Employmentship.find_by_user_id_and_company_id(user.id, company.id)
    unless employed.blank?
      return true
    end
  end
  
  def current_order
    if cookies[:order_id]
      if Order.exists?(cookies[:order_id])
        @current_order ||= Order.find(cookies[:order_id])
        cookies[:order_id] = nil if @current_order.closed_date
        cookies[:order_id] = nil if @current_order.assigned_company_id != current_company.id
      else
        cookies[:order_id] = nil
      end
    end
    if cookies[:order_id].nil?
      @current_order = Order.create!(:assigned_company_id => current_company.id, :parent_company_id => main_company.id, :closed => false)
      cookies.permanent[:order_id] = @current_order.id
    end
   #if cookies[:order_id].nil?
   #  @order = Order.company(current_company).open_order.last
   #  # try to find the last open order for this company
   #  if @order.blank? || @order.assigned_company_id != current_company.id
   #    @current_order = Order.create!(:assigned_company_id => current_company.id, :parent_company_id => main_company.id, :closed => false)
   #  else
   #    @current_order = @order
   #  end
   #  cookies.permanent[:order_id] = @current_order.id
   #end
    @current_order
  end
  
  def current_tasks
    if user_signed_in? && !current_company.blank?
      @tasks = Task.where("assigned_company = ? OR assigned_to = ?", current_company, current_user)
      @current_tasks = @tasks
    else
      @current_tasks = nil
    end
  end
  
  
  
# def current_subdomain
#     if request.subdomains.present? && request.subdomains != "www"
#       current_subdomain = Company.find_by_subdomain(request.subdomains)
#     else 
#       current_subdomain = nil
#     end
#     return current_subdomain
# end      
#
# def check_my_subdomain(subdomain)
#   if subdomain != current_subdomain.name
#     redirect_to root_url , :alert => "Sorry, resource is not part of your subdomain"
#   end
# end
  
  
  
  
  rescue_from CanCan::AccessDenied do |exception|
    if user_signed_in? && current_company.present?
      redirect_to company_dashboard_url, :alert => exception.message
    else
      redirect_to root_url, :alert => exception.message
    end
  end

protected

 def user_belongs_to_company
   unless !user_signed_in? || current_user.role == "admin" || params[:company_id] == nil 
     if current_company.present? && !current_user.company_ids.include?(current_company.id)
       redirect_to root_url, :alert => "You don't belong there!"
     end
   end
 end
 
 def after_sign_in_path_for(resource_or_scope)
   if resource_or_scope.is_a?(User) 
     if resource_or_scope.role == "banned"
        destroy_user_session_path
     else
      if resource_or_scope.companies.size == 1
        company_dashboard_url(resource_or_scope.companies.first)
      else
        root_url
      end
     end
   else
     super
   end
 end
 
  
end
