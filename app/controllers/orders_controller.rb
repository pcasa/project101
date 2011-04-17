class OrdersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  before_filter :check_if_printable, :only => :print_order
  before_filter :check_customer_change, :only => :edit
  
 # rescue_from ActiveRecord::RecordNotFound, :with => :no_order_found
  
  def index
    unless params[:customer_id]
      if current_user.role == "admin"
        @orders = Order.paginate(:page => params[:page], :per_page => 25, :order => 'id DESC')
      else
        @orders = Order.closed_orders.paginate(:page => params[:page], :per_page => 25, :order => 'id DESC')
      end
    else
      @customer = Customer.find(params[:customer_id])
      @orders = @customer.orders
    end
  end

  def show
    @order = Order.find(params[:id])
    if @order.is_a_partial_payment
      @partial_order = true
    end
  end

  def new
    @order = Order.new
    @comment = @order.build_comment
    if !params[:customer_id].blank?
      @customer = Customer.find(params[:customer_id])
      if @order.customer_id.blank? || (@order.customer_id != @customer.id)
        @order.update_attribute(:customer_id, @customer.id)
      end
    elsif !@order.customer_id.blank? && @order.customer_id != 0 # this is in case that something happens
      @customer = Customer.find(@order.customer_id)  
    else
      @order.customer = @order.build_customer
    end
  end

  def create
    @order = Order.new(params[:order])
    if @order.save
      flash[:notice] = "Successfully created order."
      redirect_to company_order_url
    else
      render :action => 'new'
    end
  end

  def edit
    @order = Order.find(params[:id])
    @comment = @order.build_comment
    if !params[:customer_id].blank?
      @customer = Customer.find(params[:customer_id])
      if @order.customer_id.blank? || (@order.customer_id != @customer.id)
        @order.update_attribute(:customer_id, @customer.id)
      end
    elsif !@order.customer_id.blank? && Customer.exists?(@order.customer_id) # this is in case that something happens
       @customer = Customer.find(@order.customer_id)
    else
      @order.update_attribute(:customer_id, nil) unless @order.customer_id.blank? #Customer Deleted. Removed Customer_id
      @order.customer = @order.build_customer
    end
   # - Refactored to abave -  
   # @order = Order.find(params[:id])
   # @comment = @order.build_comment
   # unless params[:customer_id].blank?
   #   @customer = Customer.find(params[:customer_id])
   # end
   # if @order.customer_id.blank?
   #   unless params[:customer_id].blank?
   #     @order.update_attribute(:customer_id, @customer.id)
   #   else
   #     @order.customer = @order.build_customer
   #   end
   # else
   #   unless params[:customer_id].blank?
   #     if @order.customer_id != params[:customer_id]
   #       @order.update_attribute(:customer_id, @customer.id)
   #       @order.customer_id = params[:customer_id]
   #     end
   #   else
   #     @customer = Customer.find(@order.customer_id)
   #   end 
   # end
    respond_to do |format|  
      format.html  
      format.js if request.xhr?
    end
  end

  def update
    @order = Order.find(params[:id])
    if @order.update_attributes(params[:order])
      @order.close_order
      flash[:notice] = "Successfully updated order."
      redirect_to company_order_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    flash[:notice] = "Successfully destroyed order."
    redirect_to company_orders_url
  end
  
  def make_payment_on_open_order
    @order = Order.find(params[:id])
    @order.make_partial_payment(current_order, current_user.id, current_company.id, main_company.id)
    redirect_to edit_company_order_path(current_company, current_order)
  end
  
  def all_services_popup
    @services = Service.all
    render :layout => false
  end
  
  def print_order
    @order = Order.find(params[:id])  
    render :layout => false
  end
  
  def check_if_printable
    if !@order.closed?
      flash[:alert] = "That Order is not printable!  Only Closed/Invoiced Orders can be printed."
      redirect_to company_dashboard_url(current_company)
    end
  end
  
  def no_order_found
    redirect_to company_dashboard_url, :alert => "Order not found"
  end
  
  def check_customer_change
    # Update info on existing items of original customer
    unless params[:customer_id].blank?
      @order = Order.find(params[:id])
      if !@order.customer_id.blank? && (@order.customer_id.to_s != params[:customer_id])
        @order.changed_customer(current_company)        
      end
    end
  end
  
end
