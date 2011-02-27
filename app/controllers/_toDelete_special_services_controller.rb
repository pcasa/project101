class SpecialServicesController < ApplicationController
  def index
    @special_services = SpecialService.all
  end

  def show
    @special_service = SpecialService.find(params[:id])
  end

  def new
    @special_service = SpecialService.new
  end

  def create
    @special_service = SpecialService.new(params[:special_service])
    if @special_service.save
      flash[:notice] = "Successfully created special service."
      redirect_to @special_service
    else
      render :action => 'new'
    end
  end

  def edit
    @special_service = SpecialService.find(params[:id])
  end

  def update
    @special_service = SpecialService.find(params[:id])
    if @special_service.update_attributes(params[:special_service])
      flash[:notice] = "Successfully updated special service."
      redirect_to special_service_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @special_service = SpecialService.find(params[:id])
    @special_service.destroy
    flash[:notice] = "Successfully destroyed special service."
    redirect_to special_services_url
  end
end
