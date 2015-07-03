class ProfilesController < ApplicationController

  def edit
    @user = current_user
    @profile = @user.profile
    @review = @profile.reviews.last
    @test = Test.all
  end

  def update
    @profile = Profile.find_by_id(params[:id])
    @profile.update(profile_params)
    review = @profile.reviews.last
    review.answers.each_with_index do | a, i |
      a.user_rating = user_rating_params.fetch("#{i + 1}").to_i
      a.save
    end
    redirect_to firm_path(review.firm)
  end

  def show
    @profile = current_user.profile
  end

  private

  def profile_params
    params.require(:profile).permit(:real_email, :first_name, :last_name, :country, :phone_number, :age, :gender)
  end

  def user_rating_params
    params.require(:user_rating).permit(:"1", :"2", :"3", :"4", :"5")
  end
end

# t.string :first_name
# t.string :last_name
# t.string :mother_maiden_name
# t.string :address
# t.string :phone_number
# t.string :country
# t.string :employer_name
# t.string :current_position
# t.integer :age
# t.string :gender
# t.string :real_email
