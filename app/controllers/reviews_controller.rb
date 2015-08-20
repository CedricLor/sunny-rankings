class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :edit, :destroy]
  before_action :set_review, only: [:edit, :update, :destroy]

  def create
    set_firm
    # Error handling
    redirect_to firm_path(params[:firm_id]) and return if form_has_errors?
    # If no errors
    create_new_review
    send_mail_and_redirect_user
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
    # The update method may be called by a click on:
    # - the validate button on the firm show view
    # - the validate button the review index view (user_pending_review partial)
    # - the validate button on the edit review view
    # It may also be called by clicks on the "flag" and "upvote"
    @firm = @review.firm
    update_type_switch
  end

  def destroy
    set_user
    firm = @review.firm
    destroy_and_set_flash_notices
    redirect_to firm_path(@review.firm_id) if params[:controller] == "firms" || reviews_path if params[:controller] == "reviews"
  end

  private
    ####################
    # General purposes helpers methods
    def review_params
      params.require(:review).permit(:id, :firm_id, :confirmed_t_and_c, :comment, :title, :user_firm_relationship, :up_votes, :down_votes, answers_attributes: [:user_rating, :id]) if params[:review]
    end

    def set_firm
      @firm = Firm.find(params[:firm_id])
    end

    def set_user
      user_signed_in? ? @user = current_user : @user = User.find_or_create_by_email(email: params[:email])
    end

    def set_review
      @review = Review.find(params[:id])
    end
    ####################
    # update helpers methods
    def review_params_updater
      @updated_review_params = {updated_at_ip: request.remote_ip, validated: true}
      if review_params
        @updated_review_params.merge!(review_params.except(:answers_attributes))
        @updated_review_params[:answers_attributes] = review_params[:answers_attributes].values if review_params[:answers_attributes]
      end
    end

    def is_upvote_or_flag_update
      params[:upvoteButton] || params[:flagButton]
    end

    def set_upvote_or_flag_cookies
      cookies[:ufr_store] ? upvoted_or_flagged_reviews = JSON.parse(cookies[:ufr_store]) : upvoted_or_flagged_reviews = []
      upvoted_or_flagged_reviews << { review_id: @review.id, type: params[:upvoteButton] ? "upvoteButton" : "flagButton", date: Time.now }
      cookies.permanent[:ufr_store] = JSON.generate(upvoted_or_flagged_reviews)
    end

    def remove_upvote
      params[:upvoteButton] ? @review.up_votes -= 1 : @review.up_votes
      @review.save
    end

    def remove_flag
      params[:flagButton] ? @review.down_votes -= 1 : @review.down_votes
      @review.save
    end

    def remove_cookie
      updated_cookie_content = []
      @upvoted_or_flagged_reviews.each do | review |
        unless review["review_id"] == @review.id && ( (review["type"] == "upvoteButton" && params[:upvoteButton]) || (review["type"] == "flagButton" && params[:flagButton]) )
          updated_cookie_content << review
        end
      end
      cookies.permanent[:ufr_store] = JSON.generate(updated_cookie_content)
    end

    def remove_upvote_or_flag_switch(review)
      if review["type"] == "upvoteButton" && params[:upvoteButton]
        remove_upvote
        remove_cookie
      elsif review["type"] == "flagButton" && params[:flagButton]
        remove_flag
        remove_cookie
      else
        return false
      end
    end

    def check_if_review_already_touched
      @upvoted_or_flagged_reviews = JSON.parse(cookies[:ufr_store])
      @upvoted_or_flagged_reviews.each do | review |
        if review["review_id"] == @review.id
          remove_upvote_or_flag_switch(review)
          return false
        end
      end
      true
    end

    def cookie_agrees
      if cookies[:ufr_store]
        check_if_review_already_touched
      else
        true
      end
    end

    def upvote_or_flag_update_action
      if cookie_agrees
        params[:upvoteButton] ? @review.up_votes += 1 : @review.up_votes
        params[:flagButton] ? @review.down_votes += 1 : @review.down_votes
        @review.save
      end
    end

    def upvote_or_flag_review
      if upvote_or_flag_update_action
        set_upvote_or_flag_cookies
        respond_to do |format|
          format.html { redirect_to firm_path(@firm) }
          format.js
        end
      # else
       #  respond_to do |format|
       #    format.html { render 'firms/show' }
       #    format.js
       #  end
      end
    end

    def set_successfull_update_flash_message
      if ( @review.comment.present? || @review.title.present? )
        flash[:notice] = t(
          "review_validated_but_under_review",
          scope: [:controllers, :reviews, :update],
          firm_name: @firm.name,
          default: "Your review of #{@firm.name} has been validated. Our team is currently reviewing your comments before publication."
          )
      else
        flash[:notice] = t(
          "review_validated_and_published",
          scope: [:controllers, :reviews, :update],
          firm_name: @firm.name,
          default: "Your review of #{@firm.name} has been successfully validated. You can find it hereunder."
          )
      end
    end

    def set_failed_update_fash_message
      flash[:alert] = t(
          "review_validation_failure",
          scope: [:controllers, :reviews, :update],
          firm_name: @firm.name,
          default: "Your review of #{@firm.name} could not be validated."
          )
    end

    def user_validate_review
      authenticate_user!
      review_params_updater
      if @review.update(@updated_review_params)
        set_successfull_update_flash_message
        redirect_to firm_path(@firm)
      else
        set_failed_update_flash_message
        redirect_to edit_review_path(@review)
      end
    end

    def update_type_switch
      is_upvote_or_flag_update ? upvote_or_flag_review : user_validate_review
    end
    ####################
    # create helpers methods
    def has_valid_email
      unless EmailValidator.valid?(params[:email])
        flash[:alert] = t(
            :invalid_email,
            scope: [:controllers, :reviews, :create],
            default: "Please indicate a valid email address! "
            )
        @has_errors = true
      end
    end

    def has_at_least_one_vote
      if review_params[:answers_attributes] == {}
        flash[:alert] = t(
            :no_vote_on_any_criteria,
            scope: [:controllers, :reviews, :create],
            default: "Please vote on at least one criteria! "
            )
        @has_errors = true
      end
    end

    def has_confirmed_t_and_c
      if review_params[:confirmed_t_and_c] != "1"
        flash[:alert] = t(
            :conditions_not_accepted,
            scope: [:controllers, :reviews, :create],
            default: "Please accept the conditions of use of rating services!"
            )
        @has_errors = true
      end
    end

    def form_has_errors?
      @has_errors = false
      has_valid_email
      has_at_least_one_vote
      has_confirmed_t_and_c
      @has_errors
    end
    #######
    def set_flash_notice_and_send_mail(flash_variables)
      flash[flash_variables[:flash_type]] = flash_variables[:flash_message]
      yield
    end

    def i18n_flash_messages_store(flash_message_ref)
      flash_messages_hash = {
        review_successfully_saved_logged_user: t(
            :review_successfully_saved_logged_user,
            scope: [:controllers, :reviews, :create],
            firm_name: @firm.name,
            user_email: params[:email],
            default: "Dear #{params[:email]}, your review of #{@firm.name} has been successfully saved. It is currently pending. It still needs to be validated."
            ),
        review_successfully_saved_unlogged_user: t(
            :review_successfully_saved_unlogged_user,
            scope: [:controllers, :reviews, :create],
            firm_name: @firm.name,
            user_email: params[:email],
            default: "Dear #{params[:email]}, your review of #{@firm.name} has been successfully saved. Please check your emails at #{params[:email]} to validate it!"
            )
      }
      flash_messages_hash[flash_message_ref]
    end

    def send_mail_to_user
      if user_signed_in?
        set_flash_notice_and_send_mail(
          { flash_type: "notice",
            flash_message: i18n_flash_messages_store(:review_successfully_saved_logged_user)
          }) { ReviewMailer.new_review_for(params[:email], @firm).deliver_now }
        # flash[:notice] = t(
        #     :review_successfully_saved_logged_user,
        #     scope: [:controllers, :reviews, :create],
        #     firm_name: @firm.name,
        #     user_email: params[:email],
        #     default: "Dear #{params[:email]}, your review of #{@firm.name} has been successfully saved. It is currently pending. It still needs to be validated."
        #     )
        # ReviewMailer.new_review_for(params[:email], @firm).deliver_now
      else
        set_flash_notice_and_send_mail(
          { flash_type: "notice",
            flash_message: i18n_flash_messages_store(:review_successfully_saved_unlogged_user)
          }) { @user.is_new_user_created_on_process ? @user.send_confirmation_instructions : ReviewMailer.new_review_with_your_email(params[:email], @firm).deliver_now }
        # flash[:notice] = t(
        #     :review_successfully_saved_unlogged_user,
        #     scope: [:controllers, :reviews, :create],
        #     firm_name: @firm.name,
        #     user_email: params[:email],
        #     default: "Dear #{params[:email]}, your review of #{@firm.name} has been successfully saved. Please check your emails at #{params[:email]} to validate it!"
        #     )
        # @user.is_new_user_created_on_process ? @user.send_confirmation_instructions : ReviewMailer.new_review_with_your_email(params[:email], @firm).deliver_now
      end
    end

    def send_mail_and_redirect_user
      send_mail_to_user
      redirect_to firm_path(@firm.id) and return
    end

    def create_new_review
      set_user
      @review = Review.create_review_for_user({user: @user, firm: @firm, review_params: review_params, created_at_ip: request.remote_ip})
      session[:review_token] = @review.token unless user_signed_in?
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
    ################
    # destroy helpers method
    def destroy_and_set_flash_notices
      if @review.destroy
        flash[:notice] = t(
            "review_destruction_success",
            scope: [:controllers, :reviews, :destroy],
            firm_name: firm.name,
            default: "Your review of #{firm.name} has been successfully delete."
            )
      else
        flash[:notice] = t(
            "review_destruction_failure",
            scope: [:controllers, :reviews, :destroy],
            firm_name: firm.name,
            default: "Your review of #{firm.name} could not be deleted."
            )
      end
    end
end

