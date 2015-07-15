class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: [:show, :edit, :update]

  def edit
    @user = current_user
    @profile = @user.profile
    @review = @profile.reviews.last
    @tests = Test.all

    @firm = @review.firm
    # providing variable to build ratings and trends
    @current_stage = :review_vote
    @avg_ratings_by_test = @firm.avg_ratings_by_test
    @current_period_averages = @firm.current_reporting_period_averages
    @previous_period_averages = @firm.previous_reporting_period_averages
    # providing variable for javascript immediate display
    @total_by_test = @firm.total_by_test
    @answer_count_by_test = @firm.answers_count_by_test
  end

  def update
    @profile = Profile.find_by_id(params[:id])
    updated_params = profile_params
    # first_time_login_upon_firm_review is checked by the profile edit view
    # to display a specific message to the user that logs in for the first time
    updated_params[:first_time_login_upon_firm_review] = false
    @profile.update(updated_params)
    if params[:review]
      review = @profile.reviews.last
      updated_review_params = { answers_attributes: review_params[:answers_attributes].values }
      updated_review_params[:validated] = true
      review.update(updated_review_params)
      flash[:notice] = "Dear #{current_user.real_email}, your review of #{current_user.reviews.last.firm.name} has been successfully saved."
    end
    params[:review] ? (redirect_to firm_path(review.firm)) : (redirect_to profile_path(@profile))
  end

  def show
    @profile = current_user.profile
  end

  private

  def profile_params
    params.require(:profile).permit(
      :real_email,
      :first_name,
      :last_name,
      :country,
      :phone_number,
      :age,
      :gender,
      reviews_attributes:
        [ :id,
          :validated,
          answers_attributes: [:user_rating, :id]
        ]
      )
  end

  def review_params
    params.require(:review).permit(:id, :validated, answers_attributes: [:user_rating, :id])
  end
end
