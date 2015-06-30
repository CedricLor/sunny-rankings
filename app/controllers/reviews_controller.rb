class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:pendingreviews]

  def new
    @review = Review.new
    @tests = Test.all
    if params[:firm_id].nil?
      @firms = Firm.all
    else
      @firm = Firm.find(params[:firm_id])
    end
    @answer = @review.answers.build
  end

  def create
    # if params[:review][:temporary_email].nil?
      # redirect_to
    # else
      set_user
      set_firm
      create_and_save_review
      create_and_save_answers
      if @is_new_user
        sign_in(@user)
        flash[:notice] = "Dear #{current_user.email}, your review of #{current_user.reviews.last.firm.name} has been successfully saved. To validate your vote, please update your account credentials!"
        redirect_to edit_user_registration_path
      elsif current_user
        flash[:notice] = "Dear #{current_user.email}, your review of #{current_user.reviews.last.firm.name} has been successfully saved."
        # TODO: Correct path and the whole logic of logged in users
        redirect_to pendingreviews_path
      else
        flash[:notice] = "Dear #{params[:review][:temporary_email]}, your review of #{@review.firm.name} has been successfully saved. Please login to your account #{params[:review][:temporary_email]} at Sunny Rankings to validate it!"
        redirect_to firms_path
      end
    # end
  end

  def show
  end

  def index
  end

  def pendingreviews
    @user = current_user
    @reviews = @user.reviews
    # TODO correct @ review
    @review = @reviews.last
    # TODO @firm to be refactored together with the view
    @firm = @review.firm
  end

  def confirm
    set_user
    # TODO correct @review
    @review = @user.reviews.last
    @firm = @review.firm
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def review_params
    params.require(:review).permit(:firm_id, :review_id)
  end

  def answer_params
    params.require(:user_rating).permit(:"1", :"2", :"3", :"4", :"5")
  end

  def set_firm
    # If the request comes from a firm's page
    if params[:firm_id].present?
      @firm = Firm.find(params[:firm_id])
      @firm_id = params[:firm_id]
    # If the request comes from the Rate a firm's page
    elsif params[:review][:firm_id].present?
      @firm = Firm.find(params[:review][:firm_id])
      @firm_id = @firm.id
    # Else catch
    # TODO: Not satisfactory because triggers an error later + saves a fake record into the database
    else
      @firm_id = 1000000
    end
  end

  def set_user
    if current_user.nil?
      if User.find_by_email(params[:review][:temporary_email]).nil?
        @user = create_user_on_vote
        @is_new_user = true
      else
        @user = User.find_by_email(params[:review][:temporary_email])
        @is_new_user = false
      end
    else
      @user = current_user
      @is_new_user = false
    end
  end

  def create_user_on_vote
    username = Faker::Internet.email
    password = Faker::Internet.password
    # creation of a user to be validated by user
    user = User.create({
      email: username,
      real_email: params[:review][:temporary_email],
      password: password,
      password_confirmation: password,
      validated: false
    })
    UserMailer.new_user_on_vote(user.email).deliver_now
    user
  end

  def create_and_save_review
    @review = @user.reviews.build(
      validated: false,
      user_id: @user.id,
      firm_id: @firm_id,
      user_firm_relationship: "Undefined"
      )
    @review.save
  end

  def create_and_save_answers
    @answers = []
    answer_params.each_with_index do | question_user_rating, i |
      @answers[i] = @review.answers.build(:test_id => question_user_rating[0], :user_rating => question_user_rating[1])
      @answers[i].save
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
