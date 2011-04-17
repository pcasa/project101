class TasksController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def index
    @tasks = Task.where("assigned_company = ? OR assigned_to = ? OR user_id = ?", current_company, current_user, current_user )
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
    @users = User.all
    @task.user = current_user
    @task.assigned_company = current_company.id
  end

  def create
    @task = Task.new(params[:task])
    if @task.save
      respond_to do |format|  
        format.html { 
          if @task.asset == current_company
            redirect_to company_dashboard_url(current_company), :notice => "Successfully created task."
          else
            redirect_to [current_company, @task.asset], :notice => "Successfully created task."
          end
          
        }  
        format.js if request.xhr? 
      end
    else
      respond_to do |format|
        format.html { render :action => 'new' }
        format.js if request.xhr? 
      end
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(params[:task])
      unless params[:task][:reschedule_date].blank?
        Task.create!(@task.attributes.merge(:due_at => params[:task][:reschedule_date], :deleted_at => nil, :completed_by => nil))
      end
      respond_to do |format|  
        format.html { 
          if @task.asset == current_company
            redirect_to company_dashboard_url(current_company), :notice => "Successfully updated task."
          else
            redirect_to [current_company, @task.asset], :notice => "Successfully updated task."
          end
          
        }  
        format.js if request.xhr? 
      end
    else
      render :action => 'edit'
    end
  end

  def destroy
    session[:return_to] ||= request.referer
    @task = Task.find(params[:id])
    @task.update_attribute(:user_id, current_user.id)
    @task.destroy
    flash[:notice] = "Successfully destroyed task."
    respond_to do |format|  
      format.html { redirect_to(session[:return_to] || company_tasks_url(current_company)) }  
      format.js if request.xhr?
    end
  end
end
