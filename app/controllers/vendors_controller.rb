class VendorsController < ApplicationController
  def index
    @vendors = Vendor.all
  end

  def show
    @vendor = Vendor.find(params[:id])
  end

  def new
    @vendor = Vendor.new
    @vendor.addresses.build
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
    if @vendor.addresses.blank?
      @vendor.addresses.build
    end
  end

  def update
    @vendor = Vendor.find(params[:id])
    if @vendor.update_attributes(params[:vendor])
      flash[:notice] = "Successfully updated vendor."
      redirect_to vendor_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @vendor = Vendor.find(params[:id])
    @vendor.destroy
    flash[:notice] = "Successfully destroyed vendor."
    redirect_to vendors_url
  end
end
