class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:pendingreviews, :show, :edit, :update, :destroy]

  def create
    # Error handling
    redirect_to firm_path(params[:firm_id]) and return if form_has_errors?
    # If no errors
    set_user
    set_firm
    Review.create_review_for_user({user: @user, firm: @firm, review_params: review_params})
    redirect_user
  end

  def show
  end

  def index
  end

  def pendingreviews
    @review = current_user.reviews.last
    @firm = @review.firm
    @tests = Test.all

    # providing variable to build ratings and trends
    @current_stage = :review_vote
    @avg_ratings_by_test = @firm.avg_ratings_by_test
    @current_period_averages = @firm.current_reporting_period_averages
    @previous_period_averages = @firm.previous_reporting_period_averages
    # providing variable for javascript immediate display
    @total_by_test = @firm.total_by_test
    @answer_count_by_test = @firm.answers_count_by_test
  end

  def edit
  end

  def update
    # This action is called from the view pendingreviews
    review = Review.find(params[:id])
    updated_review_params = { answers_attributes: review_params[:answers_attributes].values }
    updated_review_params[:validated] = true
    review.update(updated_review_params)
    flash[:notice] = "Dear #{current_user.profile.email}, your review of #{current_user.reviews.last.firm.name} has been successfully validated."
    redirect_to firm_path(review.firm)
  end

  def destroy
  end

  private

  def review_params
    params.require(:review).permit(:id, :firm_id, :confirmed_t_and_c, answers_attributes: [:user_rating, :id])
  end

  def set_firm
    @firm = Firm.find(params[:firm_id])
  end

  def set_user
    if current_user.nil?
      @user = User.find_or_create_by_email_address(email: params[:email])
    else
      @user = current_user
    end
  end

  def form_has_errors?
    has_errors = false
    unless EmailAddress.new(address: params[:email]).valid?
      flash[:alert] = "Please indicate a valid email address! "
      has_errors = true
    end
    if review_params[:answers_attributes] == {}
      flash[:alert] = "Please vote on at least one criteria! "
      has_errors = true
    end
    if review_params[:confirmed_t_and_c] != "1"
      flash[:alert] = "Please accept the conditions of use of rating services!"
      has_errors = true
    end
    has_errors
  end

  def redirect_user
    if current_user
      flash[:notice] = "Dear #{current_user.email}, your review of #{current_user.reviews.last.firm.name} has been successfully saved. It is currently pending. It still needs to be validated."
      redirect_to pendingreviews_path and return
    else
      flash[:notice] = "Dear #{params[:email]}, your review of #{@firm.name} has been successfully saved. Please check your emails at #{params[:email]} to validate it!"
      redirect_to new_user_session_path and return
    end
  end
end

