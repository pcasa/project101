require 'test_helper'

class HomesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Home.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Home.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Home.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to home_url(assigns(:home))
  end

  def test_edit
    get :edit, :id => Home.first
    assert_template 'edit'
  end

  def test_update_invalid
    Home.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Home.first
    assert_template 'edit'
  end

  def test_update_valid
    Home.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Home.first
    assert_redirected_to home_url(assigns(:home))
  end

  def test_destroy
    home = Home.first
    delete :destroy, :id => home
    assert_redirected_to homes_url
    assert !Home.exists?(home.id)
  end
end
