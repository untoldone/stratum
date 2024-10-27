require "application_system_test_case"

class DocumentPagesTest < ApplicationSystemTestCase
  setup do
    @document_page = document_pages(:one)
  end

  test "visiting the index" do
    visit document_pages_url
    assert_selector "h1", text: "Document pages"
  end

  test "should create document page" do
    visit document_pages_url
    click_on "New document page"

    fill_in "Document", with: @document_page.document_id
    fill_in "Index", with: @document_page.index
    click_on "Create Document page"

    assert_text "Document page was successfully created"
    click_on "Back"
  end

  test "should update Document page" do
    visit document_page_url(@document_page)
    click_on "Edit this document page", match: :first

    fill_in "Document", with: @document_page.document_id
    fill_in "Index", with: @document_page.index
    click_on "Update Document page"

    assert_text "Document page was successfully updated"
    click_on "Back"
  end

  test "should destroy Document page" do
    visit document_page_url(@document_page)
    click_on "Destroy this document page", match: :first

    assert_text "Document page was successfully destroyed"
  end
end
