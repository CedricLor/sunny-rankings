class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :edit, :update, :destroy]
  before_action :set_review, only: [:edit, :update, :destroy]

  def create
    set_firm
    # Error handling
    redirect_to firm_path(params[:firm_id]) and return if form_has_errors?
    # If no errors
    create_new_review
    redirect_user
  end

  def show

  end

  def index
    set_user
    @reviews = @user.reviews

    @number_of_validated_reviews_for_user = @user.number_of_validated_reviews

    @pending_reviews = @user.pending_reviews
    @number_of_pending_reviews_for_user = @pending_reviews.count

    @published_reviews = @user.effectively_published_reviews
    @number_of_effectively_published_reviews_for_user = @published_reviews.count

    @pending_publication_reviews = @user.pending_publication_reviews
    @number_of_reviews_pending_publication_for_user = @pending_publication_reviews.count
  end

  def edit
    @firm = @review.firm

    variables_for_review_form
  end

  def update
    @firm = @review.firm
    @updated_review_params = {}
    review_params_updater if review_params
    # The validated: true happens here and not in the partials/views
    # The update method may be called by a click on the (validate) button
    # form the firm show view or the review index view (user_pending_review partial) or
    # the edit review view (review edit view)
    @updated_review_params.merge!(validated: true, updated_at_ip: request.remote_ip)

    if @review.update(@updated_review_params)
      if ( @review.comment.present? || @review.title.present? )
        flash[:notice] = "Your review of #{@firm.name} has been validated. Our team is currently reviewing your comments before publication."
      elsif @review.comment.empty? && @review.title.empty?
        flash[:notice] = "Your review of #{@firm.name} has been successfully validated. You can find it hereunder."
      end
      redirect_to firm_path(@firm)
    else
      flash[:alert] = "Your review of #{@firm.name} could not be validated."
      redirect_to edit_review_path(@review)
    end
  end

  def destroy
    @review.destroy
    flash[:notice] = "Your review of #{@review.firm.name} has been successfully delete."
    redirect_to firm_path(@review.firm_id)
  end

  private

  def review_params
    params.require(:review).permit(:id, :firm_id, :confirmed_t_and_c, :comment, :title, answers_attributes: [:user_rating, :id]) if params[:review]
  end

  def review_params_updater
    @updated_review_params[:answers_attributes] = review_params[:answers_attributes].values if review_params[:answers_attributes]
    @updated_review_params.merge!(review_params.except(:answers_attributes))
  end

  def set_firm
    @firm = Firm.find(params[:firm_id])
  end

  def set_user
    user_signed_in == false : @user = User.find_or_create_by_email(email: params[:email]) ? @user = current_user
  end

  def set_review
    @review = Review.find(params[:id])
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
      ReviewMailer.new_review_for(params[:email], @firm).deliver_now
    else
      flash[:notice] = "Dear #{params[:email]}, your review of #{@firm.name} has been successfully saved. Please check your emails at #{params[:email]} to validate it!"
      if @user.is_new_user_created_on_vote
        ReviewMailer.first_review_for(params[:email], @firm).deliver_now
      else
        ReviewMailer.new_review_with_your_email(params[:email], @firm).deliver_now
      end
    end
    redirect_to firm_path(@firm.id) and return
  end

  def create_new_review
    set_user
    @review = Review.create_review_for_user({user: @user, firm: @firm, review_params: review_params, created_at_ip: request.remote_ip})
    session[:review_token] = @review.token if user_signed_in == false
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

