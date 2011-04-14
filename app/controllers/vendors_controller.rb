class VendorsController < ApplicationController
  before_filter :authenticate_user!
   load_and_authorize_resource
  
  def index
    @vendors = Vendor.all
  end

  def show
    @vendor = Vendor.find(params[:id])
  end

  def new
    @vendor = Vendor.new
    address = @vendor.addresses.build
  end

  def create
    @vendor = Vendor.new(params[:vendor])
    if @vendor.save
      flash[:notice] = "Successfully created vendor."
      redirect_to company_vendor_path(current_company, @vendor)
    else
      render :action => 'new'
    end
  end

  def edit
    @vendor = Vendor.find(params[:id])
    addresses = @vendor.addresses   
  end

  def update
    @vendor = Vendor.find(params[:id])
    if @vendor.update_attributes(params[:vendor])
      flash[:notice] = "Successfully updated vendor."
      redirect_to company_vendor_url(current_company, @vendor)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @vendor = Vendor.find(params[:id])
    @vendor.destroy
    flash[:notice] = "Successfully destroyed vendor."
    redirect_to company_vendors_url(current_company)
  end
end
