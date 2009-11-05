require 'test_helper'

class InviteRequestsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:invite_requests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create invite_request" do
    assert_difference('InviteRequest.count') do
      post :create, :invite_request => { }
    end

    assert_redirected_to invite_request_path(assigns(:invite_request))
  end

  test "should show invite_request" do
    get :show, :id => invite_requests(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => invite_requests(:one).to_param
    assert_response :success
  end

  test "should update invite_request" do
    put :update, :id => invite_requests(:one).to_param, :invite_request => { }
    assert_redirected_to invite_request_path(assigns(:invite_request))
  end

  test "should destroy invite_request" do
    assert_difference('InviteRequest.count', -1) do
      delete :destroy, :id => invite_requests(:one).to_param
    end

    assert_redirected_to invite_requests_path
  end
end
