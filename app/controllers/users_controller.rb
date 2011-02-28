class UsersController < ApplicationController
   before_filter :authenticate_user!
   load_and_authorize_resource
  
  def index
    # need to fix this for future where it only finds user for main or current company
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @companies = @user.companies
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.attributes = {'company_ids' => []}.merge(params[:user] || {})
    if @user.save
      flash[:notice] = "Successfully created user."
      redirect_to company_user_path(current_company, @user)
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.attributes = {'company_ids' => []}.merge(params[:user] || {})
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated user."
      redirect_to company_user_url(current_company)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "Successfully destroyed user."
    redirect_to company_users_url(current_company)
  end
  
  def dashboard
    if current_user.companies.count == '1'
      redirect_to show_company_path(current_user.companies.first)
    else
      @companies = current_user.companies
    end
  end
  
  
  
  def verify_current_user
    unless params[:verify_code] == nil
      if params[:verify_code] == current_user.passcode
        flash[:notice] = "Successfully verified passcode."
      else 
        flash[:alert] = "Code did not match!"
      end
    end
  end
  
end
