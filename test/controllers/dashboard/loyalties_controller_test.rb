require 'test_helper'

class Dashboard::LoyaltiesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dashboard_loyalties_index_url
    assert_response :success
  end

end
