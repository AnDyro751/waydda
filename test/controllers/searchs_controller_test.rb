require 'test_helper'

class SearchsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get searchs_show_url
    assert_response :success
  end

end
