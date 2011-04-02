class AdminsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def index
  end
  
  def deleted_items
    @items = Item.only_deleted
  end
  
  def item_really_destroy
    @items = Item.with_deleted
    @item = @items.find(params[:item_id])
    @item.destroy!
    respond_to do |format|
      format.html {
        redirect_to company_deleted_items_path(current_company), :notice => "Successfully destroyed item."
      }
      format.js if request.xhr?
    end
  end

  
end
