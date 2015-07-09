class ProfilesController < ApplicationController

  def edit
    @user = current_user
    @profile = @user.profile
    @review = @profile.reviews.last
    @tests = Test.all
  end

  def update
    @profile = Profile.find_by_id(params[:id])
    @profile.update(profile_params)
    @profile.update(first_time_login_upon_firm_review: false)
    review = @profile.reviews.last
    if review.validated == false
      review.answers.each_with_index do |answer, i|
        if user_rating_params[:answers_attributes]["#{i}"][:user_rating].nil?
          answer.destroy
        else
          answer.user_rating = user_rating_params[:answers_attributes]["#{i}"][:user_rating].to_i
          answer.reviewed_by_user = true
          answer.save
        end
      end
      review.update(validated: true)
      flash[:notice] = "Dear #{current_user.real_email}, your review of #{current_user.reviews.last.firm.name} has been successfully saved."
      redirect_to firm_path(review.firm)
    else
      redirect_to profile_path(@profile)
    end
  end

  def show
    @profile = current_user.profile
  end

  private

  def profile_params
    params.require(:profile).permit(:real_email, :first_name, :last_name, :country, :phone_number, :age, :gender, answers_attributes: [:user_rating])
  end

  def user_rating_params
    params.require(:review).permit(answers_attributes: [:user_rating, :id])
  end
end
