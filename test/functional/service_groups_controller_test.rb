require 'test_helper'

class ServiceGroupsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => ServiceGroup.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    ServiceGroup.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    ServiceGroup.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to service_group_url(assigns(:service_group))
  end

  def test_edit
    get :edit, :id => ServiceGroup.first
    assert_template 'edit'
  end

  def test_update_invalid
    ServiceGroup.any_instance.stubs(:valid?).returns(false)
    put :update, :id => ServiceGroup.first
    assert_template 'edit'
  end

  def test_update_valid
    ServiceGroup.any_instance.stubs(:valid?).returns(true)
    put :update, :id => ServiceGroup.first
    assert_redirected_to service_group_url(assigns(:service_group))
  end

  def test_destroy
    service_group = ServiceGroup.first
    delete :destroy, :id => service_group
    assert_redirected_to service_groups_url
    assert !ServiceGroup.exists?(service_group.id)
  end
end
