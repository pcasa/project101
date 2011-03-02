require 'test_helper'

class InsurancePoliciesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => InsurancePolicy.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    InsurancePolicy.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    InsurancePolicy.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to insurance_policy_url(assigns(:insurance_policy))
  end

  def test_edit
    get :edit, :id => InsurancePolicy.first
    assert_template 'edit'
  end

  def test_update_invalid
    InsurancePolicy.any_instance.stubs(:valid?).returns(false)
    put :update, :id => InsurancePolicy.first
    assert_template 'edit'
  end

  def test_update_valid
    InsurancePolicy.any_instance.stubs(:valid?).returns(true)
    put :update, :id => InsurancePolicy.first
    assert_redirected_to insurance_policy_url(assigns(:insurance_policy))
  end

  def test_destroy
    insurance_policy = InsurancePolicy.first
    delete :destroy, :id => insurance_policy
    assert_redirected_to insurance_policies_url
    assert !InsurancePolicy.exists?(insurance_policy.id)
  end
end
