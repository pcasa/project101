class AdminsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def index
  end
  
  def deleted_items
    @items = Item.only_deleted.paginate(:page => params[:page], :per_page => 25, :order => 'deleted_at DESC')
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
  
  def completed_tasks
    if params[:delete_task_with_id]
      if Task.with_deleted.exists?(:id => params[:delete_task_with_id])
        task = Task.with_deleted.find(params[:delete_task_with_id])
        task.destroy!
        flash[:notice] = "Deleted task with id # #{task.id}"
      end
    end
    
    @search = Task.completed.only_deleted.search(params[:search])
    @tasks = @search.paginate(:page => params[:page], :per_page => 25)
    
  end

  
end
