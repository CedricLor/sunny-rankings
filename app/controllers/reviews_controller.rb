class ReviewsController < ApplicationController
  def new
    @review = Review.new
    @tests = Test.all
    @firms = Firm.all
    @answer = @review.answers.build
  end

  def create
    set_user
    set_firm
    @review = @user.reviews.build(validated: false, user_id: @user.id, firm_id: @firm_id, user_firm_relationship: "Undefined")
    @review.save
    @answers = []
    answer_params.each_with_index do | question_user_rating, i |
      @answers[i] = @review.answers.build(:test_id => question_user_rating[0], :user_rating => question_user_rating[1])
      @answers[i].save
    end
    sign_in(@user)
  end

  def show
  end

  def index
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def review_params
    params.require(:review).permit(:firm_id)
  end

  def answer_params
    params.require(:user_rating).permit(:"1", :"2", :"3", :"4", :"5")
  end

  def set_firm
    if @firm = Firm.find_by_id(params[:review][:firm_id])
      @firm_id = @firm.id
    else
      @firm_id = 1000000
    end
  end

  def set_user
    if current_user.nil?
      @user = create_user
    else
      @user = current_user
    end
  end

  def create_user
    username = Faker::Internet.email
    password = Faker::Internet.password
    # creation of a user to be validated by user
    user = User.create({
      email: username,
      password: password,
      password_confirmation: password,
      validated: false
    })
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
