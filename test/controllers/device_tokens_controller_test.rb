require "test_helper"

class DeviceTokensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @device_token = device_tokens(:one)
  end

  test "should get index" do
    get device_tokens_url
    assert_response :success
  end

  test "should get new" do
    get new_device_token_url
    assert_response :success
  end

  test "should create device_token" do
    assert_difference("DeviceToken.count") do
      post device_tokens_url, params: { device_token: { device_id: @device_token.device_id, token: @device_token.token } }
    end

    assert_redirected_to device_token_url(DeviceToken.last)
  end

  test "should show device_token" do
    get device_token_url(@device_token)
    assert_response :success
  end

  test "should get edit" do
    get edit_device_token_url(@device_token)
    assert_response :success
  end

  test "should update device_token" do
    patch device_token_url(@device_token), params: { device_token: { device_id: @device_token.device_id, token: @device_token.token } }
    assert_redirected_to device_token_url(@device_token)
  end

  test "should destroy device_token" do
    assert_difference("DeviceToken.count", -1) do
      delete device_token_url(@device_token)
    end

    assert_redirected_to device_tokens_url
  end
end
