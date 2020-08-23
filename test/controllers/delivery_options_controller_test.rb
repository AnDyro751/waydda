require 'test_helper'

class DeliveryOptionsControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get delivery_options_update_url
    assert_response :success
  end

end
