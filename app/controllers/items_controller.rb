class ItemsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(params[:item])
    if @item.save
      flash[:notice] = "Successfully created item."
      redirect_to company_item_path(current_company, @item)
    else
      render :action => 'new'
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update_attributes(params[:item])
      flash[:notice] = "Successfully updated item."
      redirect_to edit_company_order_url(current_company, @item.order_id)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.children.destroy_all
    @item.destroy
    flash[:notice] = "Successfully destroyed item."
    redirect_to edit_company_order_url(current_company, @item.order_id)
  end
end
