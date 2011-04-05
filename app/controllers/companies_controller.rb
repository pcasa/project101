class CompaniesController < ApplicationController
  before_filter :authenticate_user!, :except => :index
  skip_authorize_resource :only => :index
  load_and_authorize_resource :only => [:show, :new, :create, :edit, :update, :destroy, :dashboard]
  
  def index
    if user_signed_in?
      if current_user.role? :admin
        @companies = Company.all
      else
        @companies = current_user.companies
      end
    end
  end

  def show
    @company = Company.find(params[:company_id])
    @users = @company.users
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(params[:company])
    if @company.save
      flash[:notice] = "Successfully created company."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end

  def edit
    @company = Company.find(params[:id])
  end

  def update
    @company = Company.find(params[:id])
    if @company.update_attributes(params[:company])
      flash[:notice] = "Successfully updated company."
      redirect_to show_company_url(@company)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @company = Company.find(params[:id])
    @company.destroy
    flash[:notice] = "Successfully destroyed company."
    redirect_to root_url
  end
  
  def dashboard
  end
  
end
