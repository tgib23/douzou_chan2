require 'test_helper'

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get welcome_home_url
	# depend on if the user is signed in or not
    #assert_response :success
    assert_response :redirect
  end

end
