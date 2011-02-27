class ServicesController < ApplicationController
 before_filter :authenticate_user!
 load_and_authorize_resource
   
  def index
    @services = Service.all
  end

  def show
    @service = Service.find(params[:id])
  end

  def new
    @service = Service.new
  end

  def create
    @service = Service.new(params[:service])
    if @service.save
      flash[:notice] = "Successfully created service."
      redirect_to company_service_url(current_company, @service)
    else
      render :action => 'new'
    end
  end

  def edit
    @service = Service.find(params[:id])
  end

  def update
    @service = Service.find(params[:id])
    if @service.update_attributes(params[:service])
      flash[:notice] = "Successfully updated service."
      redirect_to company_service_url(current_company)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @service = Service.find(params[:id])
    @service.destroy
    flash[:notice] = "Successfully destroyed service."
    redirect_to company_services_url
  end
end
