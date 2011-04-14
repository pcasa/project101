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

    
    respond_to do |format|
        if @item.update_attributes(params[:item])
          format.html { redirect_to edit_company_order_url(current_company, @item.order_id), :notice => "Successfully updated item." }
          format.js {  }
          format.json { head :ok }
        else
          format.html { render :action => "edit" }
          format.json { render :json => @item.errors.full_messages, :status => :unprocessable_entity }
        end
      end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.children.destroy_all
    @item.destroy
    respond_to do |format|
      format.html {
        redirect_to edit_company_order_url(current_company, @item.order_id), :notice => "Successfully destroyed item."
      }
      format.js if request.xhr?
    end
  end
  
  
end
