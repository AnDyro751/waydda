require 'test_helper'

class Dashboard::PromotionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dashboard_promotions_index_url
    assert_response :success
  end

end
