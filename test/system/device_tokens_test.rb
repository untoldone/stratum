require "application_system_test_case"

class DeviceTokensTest < ApplicationSystemTestCase
  setup do
    @device_token = device_tokens(:one)
  end

  test "visiting the index" do
    visit device_tokens_url
    assert_selector "h1", text: "Device tokens"
  end

  test "should create device token" do
    visit device_tokens_url
    click_on "New device token"

    fill_in "Device", with: @device_token.device_id
    fill_in "Token", with: @device_token.token
    click_on "Create Device token"

    assert_text "Device token was successfully created"
    click_on "Back"
  end

  test "should update Device token" do
    visit device_token_url(@device_token)
    click_on "Edit this device token", match: :first

    fill_in "Device", with: @device_token.device_id
    fill_in "Token", with: @device_token.token
    click_on "Update Device token"

    assert_text "Device token was successfully updated"
    click_on "Back"
  end

  test "should destroy Device token" do
    visit device_token_url(@device_token)
    click_on "Destroy this device token", match: :first

    assert_text "Device token was successfully destroyed"
  end
end
