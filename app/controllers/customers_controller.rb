class CustomersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  
  def index
    @search = Customer.search(params[:search])
    @customers = @search.relation.where("parent_company_id = ?", main_company.id).paginate(:page => params[:page], :per_page => 20)
  end

  def show
    @customer = Customer.find(params[:id])
    @parent_company = Company.find(@customer.parent_company_id)
    @assigned_company = Company.find(@customer.assigned_company_id)
    
  end

  def new
    @company = current_company
    @customer = @company.customers.new(:parent_company_id => main_company.id, :assigned_company_id => current_company.id)
    
      phone = @customer.phones.build
  end

  def create
    @customer = Customer.new(params[:customer])
    if @customer.save
      flash[:notice] = "Successfully created customer."
      redirect_to company_customer_path(current_company, @customer)
    else
      render :action => 'new'
    end
  end

  def edit
    @company= current_company
    @customer = Customer.find(params[:id])
    @companies = Company.where("id = ? OR parent_id = ?", main_company.id, main_company.id)
    phones = @customer.phones
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update_attributes(params[:customer])
      flash[:notice] = "Successfully updated customer."
      redirect_to company_customer_path(current_company, @customer)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy
    flash[:notice] = "Successfully destroyed customer."
    redirect_to company_customers_path(current_company)
  end
  
  def my_customers
    @search = Customer.search(params[:search])
    @customers = @search.relation.where("assigned_company_id = ?", current_company.id).paginate(:page => params[:page], :per_page => 20)
  end
  
  def customer_orders
    @customer = Customer.find(params[:customer_id])
    @orders = @customer.orders.closed_orders
    render :layout => false
  end
  
  def customer_policies
    @customer = Customer.find(params[:customer_id])
    @policies = @customer.insurance_policies
    render :layout => false
  end
  
  
  def customer_comments
    @customer = Customer.find(params[:customer_id])
    @comments = @customer.comments.paginate(:page => params[:page], :per_page => 10, :order => 'id DESC')
    render :layout => false
  end
  
end
