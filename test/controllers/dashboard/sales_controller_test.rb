require 'test_helper'

class Dashboard::SalesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dashboard_sales_index_url
    assert_response :success
  end

  test "should get show" do
    get dashboard_sales_show_url
    assert_response :success
  end

  test "should get edit" do
    get dashboard_sales_edit_url
    assert_response :success
  end

end
