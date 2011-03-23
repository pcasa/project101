class AdminsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def index
  end
  
  def deleted_items
    @items = Item.only_deleted
  end

  
end
