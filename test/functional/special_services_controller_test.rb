require 'test_helper'

class SpecialServicesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => SpecialService.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    SpecialService.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    SpecialService.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to special_service_url(assigns(:special_service))
  end

  def test_edit
    get :edit, :id => SpecialService.first
    assert_template 'edit'
  end

  def test_update_invalid
    SpecialService.any_instance.stubs(:valid?).returns(false)
    put :update, :id => SpecialService.first
    assert_template 'edit'
  end

  def test_update_valid
    SpecialService.any_instance.stubs(:valid?).returns(true)
    put :update, :id => SpecialService.first
    assert_redirected_to special_service_url(assigns(:special_service))
  end

  def test_destroy
    special_service = SpecialService.first
    delete :destroy, :id => special_service
    assert_redirected_to special_services_url
    assert !SpecialService.exists?(special_service.id)
  end
end
