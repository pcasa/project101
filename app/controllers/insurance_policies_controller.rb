class InsurancePoliciesController < ApplicationController
  def index
    @search = InsurancePolicy.includes([:customer, :vendor]).search(params[:search])
    @insurance_policies = @search.all.paginate(:page => params[:page], :per_page => 20)
  end

  def show
    @insurance_policy = InsurancePolicy.find(params[:id])
  end

  def new
    @insurance_policy = InsurancePolicy.new
    @insurance_policy.policy_number = params[:policy_number] 
    @insurance_policy.policy_type = params[:policy_type] 
    @insurance_policy.vendor_id = params[:vendor_id] 
    @insurance_policy.parent_id = params[:parent_id] 
    @insurance_policy.assigned_company_id = current_company.id
    @insurance_policy.parent_company_id = main_company.id
    @insurance_policy.customer_id = params[:customer_id]
  end

  def create
    @insurance_policy = InsurancePolicy.new(params[:insurance_policy])
    if @insurance_policy.save
      flash[:notice] = "Successfully created insurance policy."
      @insurance_policy.add_new_payment(current_order, current_user.id, current_company, @insurance_policy.parent_company_id, true)
      redirect_to edit_company_order_path(current_company, current_order)
    else
      flash[:error] = "Something not right."
      render :action => 'new'
    end
  end

  def edit
    @insurance_policy = InsurancePolicy.find(params[:id])
  end

  def update
    @insurance_policy = InsurancePolicy.find(params[:id])
    if @insurance_policy.update_attributes(params[:insurance_policy])
      flash[:notice] = "Successfully updated insurance policy."
      redirect_to company_insurance_policy_url(current_company)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @insurance_policy = InsurancePolicy.find(params[:id])
    @insurance_policy.destroy
    flash[:notice] = "Successfully destroyed insurance policy."
    redirect_to company_insurance_policies_url(current_company)
  end
  
  def add_policy_payment
    @insurance_policy = InsurancePolicy.find(params[:id])
    @insurance_policy.add_new_payment(current_order, current_user.id, current_company, @insurance_policy.parent_company_id, false)
    redirect_to edit_company_order_path(current_company, current_order)
  end
  
  def cancel_policy
    @insurance_policy = InsurancePolicy.find(params[:id])
    @insurance_policy.update_attribute(:cancelled_on, Time.now)
    redirect_to [current_company, @insurance_policy.customer]
  end
  
end
