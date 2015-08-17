class Answer < ActiveRecord::Base
  CURRENT_PERIOD = 30.days
  PREVIOUS_PERIOD = 90.days

  belongs_to :review
  belongs_to :test
  belongs_to :review_portfolio
  belongs_to :firm
  belongs_to :user

  validates :user_rating, presence: true
  validates :user_rating, numericality: { only_integer: true }
  validates :user_rating, inclusion: { in: (0..5) }
  validates :review, presence: true, on: :update
  validates :test, presence: true

  after_update :destroy_if_user_rating_is_0

  default_scope { includes :test }

  def sensitive
    (user_rating == 1 && test.positive_negative_switch == "negative") || (user_rating == 5 && test.positive_negative_switch == "positive")
  end

  def firm
    review.firm
  end

  def validated_answer
    review.validated == true ? true : false
  end

  def self.validated
    joins(:review).where("reviews.validated = ?", true)
  end

  def self.for_firm(firm_id)
    joins(:review).where("reviews.firm_id = ?", firm_id)
  end

  def self.current_reporting_period
    where(created_at: (Time.now - CURRENT_PERIOD)..Time.now)
  end

  def self.previous_reporting_period
    where(created_at: (Time.now - PREVIOUS_PERIOD)..Time.now - CURRENT_PERIOD)
  end

  protected

  def destroy_if_user_rating_is_0
    destroy if user_rating == 0
    destroy if user_rating == "0"
  end
end
