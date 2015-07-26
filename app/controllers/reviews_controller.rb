class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:pendingreviews, :show, :edit, :update, :destroy]

  def create
    # Error handling
    redirect_to firm_path(params[:firm_id]) and return if form_has_errors?
    # If no errors
    set_user
    set_firm
    create_and_save_review
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
    @firm_id = params[:firm_id]
  end

  def set_user
    # is the user logged in
    if current_user.nil?
      # if no, is the user already in the database
      if User.find_by_email_addresses(params[:email]).empty?
        create_user_on_vote
        @is_new_user = true
      else
        @user = User.find_by_email_addresses(params[:email])
        @is_new_user = false
      end
    # if the user is logged in, affect it to @user
    else
      @user = current_user
      @is_new_user = false
    end
  end

  def create_user_on_vote
    # creation of a user to be validated by user
    user_data = {
      email: params[:email],
      password: "1234567890",
      password_confirmation: "1234567890",
      validated: false
    }
    @user = User.create(user_data)
    UserMailer.new_user_on_vote(params[:email]).deliver_now
  end

  def create_and_save_review
    process_answers_attributes(review_params)
    @review = @user.review_portfolio.reviews.build(
      validated: false,
      firm_id: @firm_id,
      user_firm_relationship: "Undefined",
      confirmed_t_and_c: review_params[:confirmed_t_and_c],
      answers_attributes: @processed_answers_attributes
      )
    @review.save
  end

  def process_answers_attributes(review_params)
    @processed_answers_attributes = []
    for i in 1..5 do
      answer_hash = review_params[:answers_attributes].fetch("#{i - 1}") { |el| {"user_rating"=>"0"} }
      answer_hash["test_id"] = "#{i}"
      @processed_answers_attributes << answer_hash
    end
  end

  def form_has_errors?
    status = false
    if params[:email].nil? || params[:email] == ""
      flash[:alert] = "Please indicate your email! "
      status = true
    end
    if review_params[:answers_attributes] == {}
      flash[:alert] = "Please vote on at least one criteria! "
      status = true
    end
    if review_params[:confirmed_t_and_c] != "1"
      flash[:alert] = "Please accept the conditions of use of rating services!"
      status = true
    end
    status
  end

  def redirect_user
    if @is_new_user
      sign_in(@user)
      redirect_to edit_profile_path(current_user.profile.id) and return
    elsif current_user
      flash[:notice] = "Dear #{current_user.email}, your review of #{current_user.reviews.last.firm.name} has been successfully saved. It is currently pending. It still needs to be validated."
      redirect_to pendingreviews_path and return
    else
      flash[:notice] = "Dear #{params[:email]}, your review of #{@review.firm.name} has been successfully saved. Please login to your account #{@user.email} on our systems to validate it!"
      redirect_to new_user_session_path and return
    end
  end
end



  # t.integer :user_rating
  # t.references :review, index: true, foreign_key: true
  # t.references :test, index: true, foreign_key: true

# fields of a review
      # t.references :user, index: true, foreign_key: true
      # t.references :firm, index: true, foreign_key: true
      # t.string :user_firm_relationship
      # t.boolean :validated
      # :validated is not added to the review_params. This should be set by us.
# fields of an answer
      # t.integer :user_rating
      # t.references :review, index: true, foreign_key: true
      # t.references :test, index: true, foreign_key: true
