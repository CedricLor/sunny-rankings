class Review < ActiveRecord::Base
  CURRENT_PERIOD = 30.days
  PREVIOUS_PERIOD = 60.days

  belongs_to :user, inverse_of: :reviews
  belongs_to :firm, inverse_of: :reviews
  has_many :answers, inverse_of: :review, autosave: :true
  accepts_nested_attributes_for :answers

  validates :firm, presence: true
  validates :user, presence: true
  validates :confirmed_t_and_c, inclusion: { in: [true, false] }
  validates :confirmed_t_and_c, exclusion: { in: [nil] }
  validates :confirmed_t_and_c, :acceptance => {:accept => true}
  validates :validated, inclusion: { in: [true, false] }, on: :create
  validates :validated, exclusion: { in: [nil] }
  validates :validated, :acceptance => {:accept => true}, on: :update
  validates_associated :answers


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
