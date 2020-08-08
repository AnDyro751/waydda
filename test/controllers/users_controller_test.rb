require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get my_profile" do
    get users_my_profile_url
    assert_response :success
  end

  test "should get update" do
    get users_update_url
    assert_response :success
  end

  test "should get destroy" do
    get users_destroy_url
    assert_response :success
  end

  test "should get edit" do
    get users_edit_url
    assert_response :success
  end

end
