class EndorsementsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  before_filter :find_policy
  
  def index
    @endorsements = @insurance_policy.endorsements
  end

  def show
    @endorsement = Endorsement.find(params[:id])
  end

  def new
    @endorsement = Endorsement.new
  end

  def create
    @endorsement = Endorsement.new(params[:endorsement])
    if @endorsement.save
      @endorsement.add_to_order(@insurance_policy, current_order, current_user.id, current_company.id, main_company.id)
      flash[:notice] = "Successfully created endorsement."
      redirect_to edit_company_order_path(current_company, current_order)
    else
      render :action => 'new'
    end
  end

  def edit
    @endorsement = Endorsement.find(params[:id])
  end

  def update
    @endorsement = Endorsement.find(params[:id])
    if @endorsement.update_attributes(params[:endorsement])
      flash[:notice] = "Successfully updated endorsement."
      redirect_to [current_company, @insurance_policy, @endorsement]
    else
      render :action => 'edit'
    end
  end

  def destroy
    @endorsement = Endorsement.find(params[:id])
    @endorsement.destroy
    flash[:notice] = "Successfully destroyed endorsement."
    redirect_to company_insurance_policy_endorsements_url(current_company, @insurance_policy)
  end
  
  def find_policy
    @insurance_policy = InsurancePolicy.find(params[:insurance_policy_id])
  end
end
