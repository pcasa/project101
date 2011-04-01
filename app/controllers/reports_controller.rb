class ReportsController < ApplicationController
  before_filter :authenticate_user!
   load_and_authorize_resource
   
   
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
  
  def render_my_partial
    @orders = Order.where(:assigned_company_id => current_company.id)
      respond_to do |format|
        format.js if request.xhr?
      
    end
  end
  
  def full_reports
    @search = Item.valid_items.search(params[:search])
    @items = @search.paginate(:page => params[:page], :per_page => 25)
    @items_totals = @search.all
  end
  

end
