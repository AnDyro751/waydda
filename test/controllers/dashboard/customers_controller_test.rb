require 'test_helper'

class Dashboard::CustomersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dashboard_customers_index_url
    assert_response :success
  end

  test "should get show" do
    get dashboard_customers_show_url
    assert_response :success
  end

end
