require 'test_helper'

class LimitsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:limits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create limit" do
    assert_difference('Limit.count') do
      post :create, :limit => { }
    end

    assert_redirected_to limit_path(assigns(:limit))
  end

  test "should show limit" do
    get :show, :id => limits(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => limits(:one).to_param
    assert_response :success
  end

  test "should update limit" do
    put :update, :id => limits(:one).to_param, :limit => { }
    assert_redirected_to limit_path(assigns(:limit))
  end

  test "should destroy limit" do
    assert_difference('Limit.count', -1) do
      delete :destroy, :id => limits(:one).to_param
    end

    assert_redirected_to limits_path
  end
end
