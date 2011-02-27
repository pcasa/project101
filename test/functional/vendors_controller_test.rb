require 'test_helper'

class VendorsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Vendor.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Vendor.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Vendor.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to vendor_url(assigns(:vendor))
  end

  def test_edit
    get :edit, :id => Vendor.first
    assert_template 'edit'
  end

  def test_update_invalid
    Vendor.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Vendor.first
    assert_template 'edit'
  end

  def test_update_valid
    Vendor.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Vendor.first
    assert_redirected_to vendor_url(assigns(:vendor))
  end

  def test_destroy
    vendor = Vendor.first
    delete :destroy, :id => vendor
    assert_redirected_to vendors_url
    assert !Vendor.exists?(vendor.id)
  end
end
