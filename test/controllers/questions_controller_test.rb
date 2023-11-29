require "test_helper"

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @question = questions(:one)
  end

  test "should get index" do
    get api_v1_questions_url, as: :json
    assert_response :success
  end

  test "should display questions in descending order" do
    get api_v1_questions_url, as: :json
    assert_equal Question.order(created_at:  :desc), assigns(:questions)
  end

  # test "should create question" do
  #   assert_difference("Question.count") do
  #     post questions_url, params: { question: { answer: @question.answer, ask_count: @question.ask_count, context: @question.context, question: @question.question } }, as: :json
  #   end
  #
  #   assert_response :created
  # end

  test "should show question" do
    get api_v1_question_url(@question), as: :json
    assert_response :success
  end

  test "should update question" do
    patch api_v1_question_url(@question), params: { question: { answer: @question.answer, ask_count: @question.ask_count, context: @question.context, question: @question.question } }, as: :json
    assert_response :success
  end

  test "should destroy question" do
    assert_difference("Question.count", -1) do
      delete api_v1_question_url(@question), as: :json
    end

    assert_response :no_content
  end
end
