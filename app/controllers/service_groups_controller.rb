class ServiceGroupsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
   
  def index
    @service_groups = ServiceGroup.all
  end

  def show
    @service_group = ServiceGroup.find(params[:id])
  end

  def new
    @service_group = ServiceGroup.new
  end

  def create
    @service_group = ServiceGroup.new(params[:service_group])
    if @service_group.save
      flash[:notice] = "Successfully created service group."
      redirect_to company_service_group_path(current_company, @service_group)
    else
      render :action => 'new'
    end
  end

  def edit
    @service_group = ServiceGroup.find(params[:id])
  end

  def update
    @service_group = ServiceGroup.find(params[:id])
    if @service_group.update_attributes(params[:service_group])
      flash[:notice] = "Successfully updated service group."
      redirect_to company_service_group_url(current_company, @service_group)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @service_group = ServiceGroup.find(params[:id])
    @service_group.destroy
    flash[:notice] = "Successfully destroyed service group."
    redirect_to company_service_groups_url(current_company)
  end
  
  def add_to_order
    @service_group = ServiceGroup.find(params[:id])
    @parent_item = Item.create!(@service_group.attributes.merge(:items => @service_group.items, :order_id => current_order.id, :itemable => @service_group, :qty => 1, :visible => true, :assigned_company_id => current_company.id, :parent_company_id => main_company.id))
    @service_group.services.each do |service|
      @child_item = Item.create!(service.attributes.merge(:items => service.items, :order_id => current_order.id, :itemable => service, :parent_id => @parent_item.id, :visible => false, :qty => 1, :assigned_company_id => current_company.id, :parent_company_id => main_company.id))
    end
    redirect_to edit_company_order_url(current_company, current_order)
  end
end
