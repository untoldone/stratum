require "test_helper"

class DocumentPagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @document_page = document_pages(:one)
  end

  test "should get index" do
    get document_pages_url
    assert_response :success
  end

  test "should get new" do
    get new_document_page_url
    assert_response :success
  end

  test "should create document_page" do
    assert_difference("DocumentPage.count") do
      post document_pages_url, params: { document_page: { document_id: @document_page.document_id, index: @document_page.index } }
    end

    assert_redirected_to document_page_url(DocumentPage.last)
  end

  test "should show document_page" do
    get document_page_url(@document_page)
    assert_response :success
  end

  test "should get edit" do
    get edit_document_page_url(@document_page)
    assert_response :success
  end

  test "should update document_page" do
    patch document_page_url(@document_page), params: { document_page: { document_id: @document_page.document_id, index: @document_page.index } }
    assert_redirected_to document_page_url(@document_page)
  end

  test "should destroy document_page" do
    assert_difference("DocumentPage.count", -1) do
      delete document_page_url(@document_page)
    end

    assert_redirected_to document_pages_url
  end
end
