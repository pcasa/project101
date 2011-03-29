class ReportsController < ApplicationController
  
  def index
  end
  
  def store_reports
    @orders = Order.where(:assigned_company_id => current_company.id)
  end
  
  def policy_reports
    @orders = Order.where(:assigned_company_id => current_company.id)
    respond_to do |format|
      format.html
      format.js if request.xhr? 
    end
  end
  
  
  def set_orders
    @orders = Order.where(:assigned_company_id => current_company.id)
  end

end
