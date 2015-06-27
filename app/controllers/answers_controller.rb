class AnswersController < ApplicationController
  # before_action :select_review, only: [ :create ]

  # def create
  #   @answer = @review.answers.build(answer_params)
  #   @answer.save
  # end

  # private

  # def answer_params
  #   params.require(:answer).permit(:user_rating)
  # end

  # def select_review
  #   @review = Review.find(params[:review_id])
  # end
end
