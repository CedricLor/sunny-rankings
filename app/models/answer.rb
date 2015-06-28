class Answer < ActiveRecord::Base
  belongs_to :review
  belongs_to :test

  def sensitive
    (user_rating == 1 && test.positive_negative_switch == "negative") || (user_rating == 5 && test.positive_negative_switch == "positive")
  end
end
