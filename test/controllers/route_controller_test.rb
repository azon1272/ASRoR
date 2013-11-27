require 'test_helper'

class RouteControllerTest < ActionController::TestCase
  test "should get get_route" do
    get :get_route
    assert_response :success
  end

  test "should get view_information" do
    get :view_information
    assert_response :success
  end

end
