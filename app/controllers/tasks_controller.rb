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
      flash[:notice] = "Successfully created task."
      respond_to do |format|  
        format.html { 
          if @task.asset == current_company
            redirect_to company_dashboard_url(current_company)
          else
            redirect_to [current_company, @task.asset]
          end
          
        }  
        format.js if request.xhr?
      end
    else
      render :action => 'new'
    end
  end

  def edit
    @task = Task.find(params[:id])
    @users = User.all
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(params[:task])
      flash[:notice] = "Successfully updated task."
      redirect_to company_task_url(current_company, @task)
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
