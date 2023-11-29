require 'csv'
require 'openai'
require 'dotenv'
require 'matrix'
require 'daru'
require './config/initializers/constants'
require './lib/services/AskService'

class Api::V1::AsksController < ApplicationController
  skip_before_action :require_login, only: [:index, :create]
  # GET /asks
  def index
    @answer = nil
    render json: {"question": "What is The Minimalist Entrepreneur about?" }
  end


  # POST /asks
  def create
    unless request.POST.include? "question"
      puts "Please ask a question"
    end

    ask_service = Services::AskService.new(request.POST[:question])

    previous_question =  Question.find_by(question: ask_service.question)
    if previous_question.present?
      previous_question.ask_count = previous_question.ask_count.to_i + 1
      previous_question.save
      render json: {"question": previous_question.question, "answer": previous_question.answer, "id": previous_question.id}
    else
      answer, context = ask_service.find_answer
      question = Question.new(:question => ask_service.question, :answer => answer, :context => context)
      question.save
      render json: {"question": question.question, "answer": answer, "id": question.id}
    end

  end

end
