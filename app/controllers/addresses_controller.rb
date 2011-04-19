class AddressesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  #
  
  def index
    @addressable = find_addressable
    @addresses = @addressable.addresses
  end

  def show
    @address = Address.find(params[:id])
  end

  def new
    @address = Address.new
  end

  def create
    @addressable = find_addressable
    @address = @addressable.address.build(params[:address])
    if @address.save
      flash[:notice] = "Successfully created address."
      redirect_to :id => nil
    else
      render :action => 'new'
    end
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    if @address.update_attributes(params[:address])
      if @address.addressable_type == "Company"
        redirect_to root_url
      else
        go_to = @address.addressable_type.downcase.pluralize
        redirect_to :controller => @address.addressable_type.downcase.pluralize, :action => 'show', :id => @address.addressable_id.to_i
      end
    else
      render :action => 'edit'
    end
  end

  def destroy
    @address = Address.find(params[:id])
    @address.destroy
    flash[:notice] = "Successfully destroyed address."
    redirect_to :controller => @address.addressable_type.downcase.pluralize, :action => 'show', :id => @address.addressable_id.to_i
  end
  
  private
  
  def find_addressabe
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
