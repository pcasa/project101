class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new
    
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
    if @order.customer_id.blank?
      unless params[:customer_id].blank?
        @customer = Customer.find(params[:customer_id])
      else
        @order.customer = @order.build_customer
      end
    else
      unless params[:customer_id].blank?
        if @order.customer_id != params[:customer_id]
          @order.customer_id = params[:customer_id]
        end
        @customer = Customer.find(params[:customer_id])
      else
        @customer = Customer.find(@order.customer_id)
      end 
    end
  end

  def update
    @order = Order.find(params[:id])
    if @order.update_attributes(params[:order])
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
  
  def all_services_popup
    @services = Service.all
    @service_groups = ServiceGroup.all
    render :layout => false
  end
end
