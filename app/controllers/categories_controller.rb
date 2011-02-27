class CategoriesController < ApplicationController
#  before_filter :authenticate_user!
#  load_and_authorize_resource
#  before_filter :check_if_in_subdomain
   
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    @parent_category = Category.find(@category.parent_id)
  end

  def new
    @category = Category.new
    @categories = Category.all
  end

  def create
    @category = Category.new(params[:category])
    if @category.save
      flash[:notice] = "Successfully created category."
      redirect_to @category
    else
      render :action => 'new'
    end
  end

  def edit
    @category = Category.find(params[:id])
    @categories = Category.where("id IS NOT ?", @category)
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      flash[:notice] = "Successfully updated category."
      redirect_to category_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    flash[:notice] = "Successfully destroyed category."
    redirect_to categories_url
  end
end
