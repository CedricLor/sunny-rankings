class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def update
  end

  def edit

  end

  def reconcile
    # If the user used the fake email provided to him
    if users_params[:real_email] == current_user.email
       user_providing_username_as_real_email
    # Else if the user has provided an email
    else
      is_user_already_registered? ? user_already_registered : new_user_on_vote
    end
  end

  private

  def users_params
    params.require(:user).permit(:real_email)
  end

  def user_providing_username_as_real_email
    # load a warning message in the flash
    flash[:alert] = "Please provide a valid email."
    # redirect to the confirm_review view
    redirect_to confirm_review_path(current_user.reviews.last)
  end

  def is_user_already_registered?
    if @user = User.find_by_real_email(users_params[:real_email]) || @user = User.find_by_email(users_params[:real_email])
      true
    else
      false
    end
  end

  def user_already_registered
    current_review = current_user.reviews.last
    # attach the current review to the real user
    current_review.user_id = @user.id
    # save the current review to the database
    current_review.save
    # store the id of the temporary account to be destroyed
    id_of_user_to_be_destroyed = current_user
    # close the temporary account
    sign_out current_user
    # destroy the temporary account
    User.find(id_of_user_to_be_destroyed).destroy
    # define a message for the user to inform him that his review has been saved
    # TO DO NOW: Send an email to the user to inform him of a new review associated with his name
    flash[:notice] = "Dear #{users_params[:real_email]}, your review of #{current_review.firm.name} has been successfully saved. Please login to your account #{users_params[:real_email]} at Sunny Rankings to validate it!"
    # redirect to login
    redirect_to new_user_session_path
  end

  def new_user_on_vote
    current_user.real_email = users_params[:real_email]
    current_user.save
    flash[:notice] = "Dear #{current_user.email}, your review of #{current_user.reviews.last.firm.name} has been successfully saved. To validate your vote, please update your account credentials!"
    UserMailer.new_user_on_vote(users_params[:real_email]).deliver_now
    redirect_to edit_user_registration_path
    # @real_email = users_params[:real_email]
    # render :pendinguservalidation
  end
end
