class Answer < ActiveRecord::Base
  CURRENT_PERIOD = 20.days
  PREVIOUS_PERIOD = 60.days

  belongs_to :review, inverse_of: :answers
  default_scope { order(:id) }
  belongs_to :test, inverse_of: :answers

  def sensitive
    (user_rating == 1 && test.positive_negative_switch == "negative") || (user_rating == 5 && test.positive_negative_switch == "positive")
  end

  def firm
    review.firm
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
end
