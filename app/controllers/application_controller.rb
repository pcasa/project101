class ApplicationController < ActionController::Base
  include UrlHelper
  protect_from_forgery
  helper_method :current_company, :main_company, :is_employed_at?
  
  
  
  
  
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
    redirect_to root_url, :alert => exception.message
  end

protected
  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a?(User) 
      users_dashboard_url
    else
      super
    end
  end
 
  
end
