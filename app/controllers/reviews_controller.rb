class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:pendingreviews, :show, :edit, :update, :destroy]

  def new
    @review = Review.new
    @tests = Test.all
    if params[:firm_id].nil?
      @firms = Firm.all
    else
      @firm = Firm.find(params[:firm_id])
    end
    Test.all.length.times { @review.answers.build }
  end


  def create
    # Error handling
    form_has_errors?
    # If no errors
    set_user
    set_firm
    create_and_save_review
    create_and_save_answers
    redirect_user
  end

  def show
  end

  def index
  end

  def pendingreviews
    @user = current_user
    @reviews = @user.reviews
    # TODO correct @ review to loop over @reviews
    @review = @reviews.last
    # TODO @firm to be refactored together with the view
    @firm = @review.firm
    @test = Test.all
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def review_params
    # params.require(:review).permit!
    params.require(:review).permit(:firm_id, :temporary_email, :confirmed_t_and_c, answers_attributes: [:user_rating])
  end

  def answer_params
    params.require(params[:review][:answers_attributes]).permit(:"1", :"2", :"3", :"4", :"5")
  end

  def set_firm
    # If the request comes from a firm's page
    if params[:firm_id].present?
      @firm = Firm.find(params[:firm_id])
      @firm_id = params[:firm_id]
    # If the request comes from the Rate a firm's page
    elsif review_params[:firm_id].present?
      @firm = Firm.find(review_params[:firm_id])
      @firm_id = @firm.id
    # Else catch
    # TODO: Not satisfactory because triggers an error later + saves a fake record into the database
    else
      @firm_id = 1000000
    end
  end

  def set_user
    # is the user logged in
    if current_user.nil?
      # if no, is the user already in the database
      if is_user_already_registered?
        @is_new_user = false
      # if the user is not in the database, create a new user
      else
        @user = create_user_on_vote
        @is_new_user = true
      end
    # if the user is logged in, affect it to @user
    else
      @user = current_user
      @is_new_user = false
    end
  end

  def is_user_already_registered?
    if User.find_by_real_email(review_params[:temporary_email]).nil? && User.find_by_email(review_params[:temporary_email]).nil?
      return false
    else
      if User.find_by_real_email(review_params[:temporary_email]).nil?
        @user = User.find_by_email(review_params[:temporary_email])
        return true
      else
        @user = User.find_by_real_email(review_params[:temporary_email])
        return true
      end
    end
  end

  def create_user_on_vote
    username = Faker::Internet.email
    # password = Faker::Internet.password
    password = "1234567890"
    # creation of a user to be validated by user
    user = User.create({
      email: username,
      real_email: review_params[:temporary_email],
      password: password,
      password_confirmation: password,
      validated: false
    })
    @profile = user.create_profile(real_email: review_params[:temporary_email])
    UserMailer.new_user_on_vote(user.email).deliver_now
    user
  end

  def create_and_save_review
    @review = @user.reviews.build(
      validated: false,
      user_id: @user.id,
      firm_id: @firm_id,
      user_firm_relationship: "Undefined",
      confirmed_t_and_c: review_params[:confirmed_t_and_c]
      )
    @review.save
  end

  def create_and_save_answers
    @answers = []
    review_params[:answers_attributes].each_with_index do | question_user_rating, i |
      @answers[i] = @review.answers.build(:test_id => question_user_rating[0].to_i + 1, :user_rating => question_user_rating[1][:user_rating].to_i)
      # + 1 is here to correct the 0 index (there is no test with index 0 in the database)
      @answers[i].save
    end
  end

  def form_has_errors?
    if review_params[:temporary_email].nil? || "" == review_params[:temporary_email]
      alert_message = "Please indicate your email!"
      firm_id = params[:firm_id] || review_params[:firm_id]
      if Firm.find_by_id(firm_id).nil?
        flash[:alert] = alert_message + " Please choose the firm you want to vote for!"
        redirect_to new_review_path and return
      else
        flash[:alert] = alert_message
        redirect_to firm_path(firm_id) and return
      end
    end
    # if params[:firm_id]
    #   flash[:alert] = "Please indicate your email!"
    #   redirect_to firm_path(params[:firm_id])
    # elsif params[:review][:firm_id]
    #     flash[:alert] = "Please indicate your email!"
    #     redirect_to firm_path(params[:review][:firm_id])
    #     # @review = Review.new(firm_id: params[:review][:firm])
    #     # create_and_save_answers
    #     # @tests = Test.all
    #     # @firms = Firm.all
    #     # raise Exception @review.inspect
    #     # render :new
    # end
  end

  def redirect_user
    if @is_new_user
      sign_in(@user)
      redirect_to edit_profile_path(@profile) and return
    elsif current_user
      flash[:notice] = "Dear #{current_user.email}, your review of #{current_user.reviews.last.firm.name} has been successfully saved."
      redirect_to pendingreviews_path and return
    else
      flash[:notice] = "Dear #{review_params[:temporary_email]}, your review of #{@review.firm.name} has been successfully saved. Please login to your account #{@user.email} at Sunny Rankings to validate it!"
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
