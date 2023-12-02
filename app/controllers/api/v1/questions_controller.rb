class Api::V1::QuestionsController < ApplicationController
  before_action :set_question, only: %i[ show ]
  before_action :require_login,  only: %i[ index ]


  # GET /questions
  def index
    @questions = Question.order(ask_count: :desc)
    render json: @questions
  end

  # GET /questions/1
  def show
    render json: @question
  end

  # POST /questions
  def create
    @question = Question.new(question_params)

    if @question.save
      render json: @question, status: :created, location: @question
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_question
    @question = Question.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def question_params
    params.require(:question).permit(:question, :context, :answer, :ask_count)
  end
end
