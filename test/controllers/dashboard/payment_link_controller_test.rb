require 'test_helper'

class Dashboard::PaymentLinkControllerTest < ActionDispatch::IntegrationTest
  test "should get soon" do
    get dashboard_payment_link_soon_url
    assert_response :success
  end

end
