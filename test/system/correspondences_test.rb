require "application_system_test_case"

class CorrespondencesTest < ApplicationSystemTestCase
  setup do
    @correspondence = correspondences(:one)
  end

  test "visiting the index" do
    visit correspondences_url
    assert_selector "h1", text: "Correspondences"
  end

  test "should create correspondence" do
    visit correspondences_url
    click_on "New correspondence"

    fill_in "Document", with: @correspondence.document_id
    fill_in "Recipient", with: @correspondence.recipient
    fill_in "Sender", with: @correspondence.sender
    fill_in "Sent at", with: @correspondence.sent_at
    fill_in "Subject", with: @correspondence.subject
    click_on "Create Correspondence"

    assert_text "Correspondence was successfully created"
    click_on "Back"
  end

  test "should update Correspondence" do
    visit correspondence_url(@correspondence)
    click_on "Edit this correspondence", match: :first

    fill_in "Document", with: @correspondence.document_id
    fill_in "Recipient", with: @correspondence.recipient
    fill_in "Sender", with: @correspondence.sender
    fill_in "Sent at", with: @correspondence.sent_at.to_s
    fill_in "Subject", with: @correspondence.subject
    click_on "Update Correspondence"

    assert_text "Correspondence was successfully updated"
    click_on "Back"
  end

  test "should destroy Correspondence" do
    visit correspondence_url(@correspondence)
    click_on "Destroy this correspondence", match: :first

    assert_text "Correspondence was successfully destroyed"
  end
end
