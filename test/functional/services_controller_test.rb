require 'test_helper'

class ServicesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Service.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Service.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Service.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to service_url(assigns(:service))
  end

  def test_edit
    get :edit, :id => Service.first
    assert_template 'edit'
  end

  def test_update_invalid
    Service.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Service.first
    assert_template 'edit'
  end

  def test_update_valid
    Service.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Service.first
    assert_redirected_to service_url(assigns(:service))
  end

  def test_destroy
    service = Service.first
    delete :destroy, :id => service
    assert_redirected_to services_url
    assert !Service.exists?(service.id)
  end
end
