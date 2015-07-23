class AssociationCountValidator < ActiveModel::Validations::LengthValidator
  MESSAGES = { :wrong_length => :association_count_invalid,
               :too_short => :association_count_greater_than_or_equal_to,
               :too_long => :association_count_less_than_or_equal_to }.freeze

  def initialize(options)
    MESSAGES.each { |key, message| options[key] ||= message }
    super
  end

  def validate_each(record, attribute, value)
    existing_records = record.send(attribute).reject(&:marked_for_destruction?)
    super(record, attribute, existing_records)
  end
end

class Review < ActiveRecord::Base
  CURRENT_PERIOD = 30.days
  PREVIOUS_PERIOD = 60.days
  ANSWERS_REQUIRED_COUNT = 5
  ANSWERS_MINIMUM_COUNT = 1

  belongs_to :user, inverse_of: :reviews
  belongs_to :firm, inverse_of: :reviews
  has_many :answers, inverse_of: :review, autosave: :true
  accepts_nested_attributes_for :answers, limit: 5, allow_destroy: true

  validates :firm, presence: true
  validates :user, presence: true
  validates :confirmed_t_and_c, inclusion: { in: [true, false] }
  validates :confirmed_t_and_c, exclusion: { in: [nil] }
  validates :confirmed_t_and_c, acceptance: {
    accept: true,
    message: "You have to agree to the conditions of use of our services on each vote."
  }
  validates :validated, inclusion: { in: [true, false] }, on: :create
  validates :validated, exclusion: { in: [nil] }
  validates :validated, :acceptance => {:accept => true}, on: :update

  validates_associated :answers
  validates :answers, association_count: { is: ANSWERS_REQUIRED_COUNT }, on: :save
  validates :answers, association_count: { maximum: ANSWERS_REQUIRED_COUNT }, on: :update
  validates :answers, association_count: { minimum: ANSWERS_MINIMUM_COUNT }

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
