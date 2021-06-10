require 'test_helper'

class CheckControllerTest < ActionDispatch::IntegrationTest
  test "should get check" do
    get check_check_url
    assert_response :success
  end

end
