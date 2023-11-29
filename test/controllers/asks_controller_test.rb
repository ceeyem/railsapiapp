require "test_helper"

class AsksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ask = asks(:one)
  end

  test "should get index" do
    get asks_url, as: :json
    assert_response :success
  end

  test "should create ask" do
    assert_difference("Ask.count") do
      post asks_url, params: { ask: { question: @ask.question } }, as: :json
    end

    assert_response :created
  end

  test "should show ask" do
    get ask_url(@ask), as: :json
    assert_response :success
  end

  test "should update ask" do
    patch ask_url(@ask), params: { ask: { question: @ask.question } }, as: :json
    assert_response :success
  end

  test "should destroy ask" do
    assert_difference("Ask.count", -1) do
      delete ask_url(@ask), as: :json
    end

    assert_response :no_content
  end
end
