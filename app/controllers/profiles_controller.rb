class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: [:show, :edit, :update]
  before_action :set_profile, only: [:show, :edit, :update]

  def edit
    unless @review = current_user.reviews.last.nil?
      if @review.validated == false
        variables_for_pending_review
      end
    end
  end

  def update
    if params[:review]
      @review = @profile.reviews.last
      updated_review_params = { answers_attributes: review_params[:answers_attributes].values }
      updated_review_params[:validated] = true
      updated_review_params[:id] = @review.id
      params[:profile][:reviews_attributes] = [updated_review_params]
    end
    if @profile.update(profile_params)
      params[:review] ? (redirect_to firm_path(@review.firm_id)) : (redirect_to profile_path(@profile.id))
    else
      variables_for_pending_review
      render :edit
    end
  end

  def show
  end

  private

  def profile_params
    params.require(:profile).permit(
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
        ],
      email_addresses_attributes:
        [ :id,
          :address,
          :profile_id
        ]
      )
    # TO DO in email_addresses_attributes, check that id and profile_id are required
  end

  def review_params
    params.require(:review).permit(answers_attributes: [:user_rating, :id])
  end

  def set_profile
    @profile = current_user.profile
  end

  def variables_for_pending_review
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
end
