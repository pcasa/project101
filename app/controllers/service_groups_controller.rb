class ServiceGroupsController < ApplicationController
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
end
