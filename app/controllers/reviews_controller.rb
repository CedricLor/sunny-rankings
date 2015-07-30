class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :edit, :update, :destroy]

  def create
    # Error handling
    redirect_to firm_path(params[:firm_id]) and return if form_has_errors?
    # If no errors
    set_user
    set_firm
    @review = Review.create_review_for_user({user: @user, firm: @firm, review_params: review_params})
    redirect_user
  end

  def show
  end

  def index
    @reviews = current_user.reviews

    @validated_but_not_agreed_for_publication_reviews = current_user.validated_but_not_agreed_for_publication_reviews_with_answers_and_test_names_for_publication
    @number_of_validated_but_not_agreed_for_publication_reviews = @validated_but_not_agreed_for_publication_reviews.count

    @number_of_validated_reviews_for_user = current_user.number_of_validated_reviews
    @number_of_agreed_for_publication_reviews_for_user = current_user.number_of_agreed_for_publication_reviews

    @pending_reviews = current_user.pending_reviews
    @number_of_pending_reviews_for_user = @pending_reviews.count

    @published_reviews = current_user.effectively_published_reviews
    @number_of_effectively_published_reviews_for_user = @published_reviews.count

    @pending_publication_reviews = current_user.pending_publication_reviews
    @number_of_reviews_pending_publication_for_user = @pending_publication_reviews.count
  end

  def edit
    @review = Review.find(params[:id])
    @firm = @review.firm

    variables_for_review_form
  end

  def update
    review = Review.find(params[:id])
    @updated_review_params = {}
    review_params_updater unless params[:review].nil?
    @updated_review_params[:validated] = true

    if review.update(@updated_review_params)
      if review.agreed_for_publication && ( review.comment.present? || review.title.present? )
        flash[:notice] = "Dear #{current_user.profile.email}, thank you for agreeing to make your review of #{current_user.reviews.last.firm.name} public. Our team is currently reviewing your comments before publication."
      elsif review.agreed_for_publication && review.comment.empty? && review.title.empty?
        flash[:notice] = "Dear #{current_user.profile.email}, your review of #{current_user.reviews.last.firm.name} has been successfully validated."
      elsif review.agreed_for_publication == false
        flash[:notice] = "Dear #{current_user.profile.email}, your review of #{current_user.reviews.last.firm.name} has been successfully validated. You may now decide to publish it."
      end
      redirect_to firm_path(review.firm)
    else
      flash[:alert] = "Dear #{current_user.profile.email}, your review of #{current_user.reviews.last.firm.name} could not be validated."
      redirect_to edit_review_path(review)
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    flash[:notice] = "Dear #{current_user.email}, your review of #{@review.firm.name} has been successfully delete."
    redirect_to firm_path(@review.firm_id)
  end

  private

  def review_params
    params.require(:review).permit(:id, :firm_id, :confirmed_t_and_c, :comment, :title, :agreed_for_publication, answers_attributes: [:user_rating, :id])
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
    unless EmailValidator.valid?(params[:email])
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
      flash[:notice] = "Dear #{params[:email]}, your review of #{@firm.name} has been successfully saved. It is currently pending. It still needs to be validated."
      redirect_to firm_path(@review.firm_id) and return
    else
      flash[:notice] = "Dear #{params[:email]}, your review of #{@firm.name} has been successfully saved. Please check your emails at #{params[:email]} to validate it!"
      redirect_to new_user_session_path and return
    end
  end

  def review_params_updater
    @updated_review_params = { answers_attributes: review_params[:answers_attributes].values } if review_params[:answers_attribues]
    review_params.each do | param |
      @updated_review_params[param[0]] = param[1] unless param[0] == "answers_attributes"
    end
  end

  def variables_for_review_form
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
end

