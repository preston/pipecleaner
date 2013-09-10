require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test "should get landing" do
    get :landing
    assert_response :success
  end

  test "should get dashboard" do
    get :dashboard
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end

end
