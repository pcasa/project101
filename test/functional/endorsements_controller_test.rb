require 'test_helper'

class EndorsementsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Endorsement.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Endorsement.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Endorsement.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to endorsement_url(assigns(:endorsement))
  end

  def test_edit
    get :edit, :id => Endorsement.first
    assert_template 'edit'
  end

  def test_update_invalid
    Endorsement.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Endorsement.first
    assert_template 'edit'
  end

  def test_update_valid
    Endorsement.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Endorsement.first
    assert_redirected_to endorsement_url(assigns(:endorsement))
  end

  def test_destroy
    endorsement = Endorsement.first
    delete :destroy, :id => endorsement
    assert_redirected_to endorsements_url
    assert !Endorsement.exists?(endorsement.id)
  end
end
