class TasksController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def index
    @asset = find_asset
    @tasks = @asset.tasks
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
      redirect_to [current_company, @task]
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
    @task = Task.find(params[:id])
    @task.update_attribute(:user_id, current_user.id)
    @task.destroy
    flash[:notice] = "Successfully destroyed task."
    redirect_to company_tasks_url(current_company)
  end
  
  private

  def find_asset
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
