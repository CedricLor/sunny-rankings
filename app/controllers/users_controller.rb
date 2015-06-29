class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def update

  end

  def edit

  end

  def reconcile
    # If the user used the fake email provided to him
    if params[:user][:real_email] == current_user.email
      # look up the latest review associated to its temporary account
      @review = current_user.reviews.last
      # load a warning message in the flash
      flash[:alert] = "Please provide a valid email."
      # redirect to the confirm_review view
      redirect_to confirm_review_path(@review)
    # Else if the user has provided an email
    else
      # if the user is found in the database of users
      if @user = User.find_by_email(params[:user][:real_email])
        current_review = current_user.reviews.last
        # attach the current review to the real user
        current_review.user_id = @user.id
        # save the current review to the database
        current_review.save
        # destroy the temporary account
        current_user.destroy
        # close the temporary account
        sign_out current_user
        # redirect to login
        redirect_to new_user_session_path
      # If the email provided by the user does not correspond
      # to an existing account
      else
        # send him an email to invite him to create a profile
        UserMailer.new_user_on_vote(params[:user][:real_email]).deliver_now
        @real_email = params[:user][:real_email]
        render :pendinguservalidation
      end
    end

    def pendinguservalidation

    end
  end

  private

  def users_params
    params.require(:user).permit(:real_email)
  end
end
