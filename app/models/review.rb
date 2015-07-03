class Review < ActiveRecord::Base
  CURRENT_PERIOD = 30.days
  PREVIOUS_PERIOD = 60.days

  belongs_to :user
  belongs_to :firm
  has_many :answers
  accepts_nested_attributes_for :answers

  def self.answers
    joins(:answers)
  end

  def self.for_firm(firm_id)
    where(firm_id: firm_id)
  end

  def self.current_reporting_period
    where(created_at: (Time.now - CURRENT_PERIOD)..Time.now)
  end

  def self.previous_reporting_period
    where(created_at: (Time.now - PREVIOUS_PERIOD)..Time.now - CURRENT_PERIOD)
  end

  def contains_sensitive_answers
    response = { sensitive: false, count: 0}
    answers.each do | answer |
      if answer.sensitive
        response[:sensitive] = true
        response[:count] += 1
      end
    end
    response
  end
end
