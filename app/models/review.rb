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

  belongs_to :review_portfolio
  belongs_to :firm
  belongs_to :user
  delegate :user, to: :review_portfolio

  has_many :answers, autosave: :true, dependent: :destroy

  accepts_nested_attributes_for :answers, limit: 5, allow_destroy: true

  validates :firm, presence: true
  validates :review_portfolio, presence: true, on: :update
  validates :confirmed_t_and_c, inclusion: { in: [true] }
  validates :confirmed_t_and_c, exclusion: { in: [nil] }
  validates :confirmed_t_and_c, acceptance: {
    accept: true,
    message: "You have to agree to the conditions of use of our services on each vote."
  }
  validates :validated, inclusion: { in: [true, false] }, on: :create
  validates :validated, exclusion: { in: [nil] }
  validates :validated, :acceptance => {:accept => true}, on: :update, unless: "token_changed?"

  validates_associated :answers
  validates :answers, association_count: { is: ANSWERS_REQUIRED_COUNT }, on: :save
  validates :answers, association_count: { maximum: ANSWERS_REQUIRED_COUNT }, on: :update
  validates :answers, association_count: { minimum: ANSWERS_MINIMUM_COUNT }

  validate :featured_checker

  before_create :generate_token, unless: :token?
  before_update :switch_publishable_to_true

  def featured_checker
    if featured == true
      if publishable == false
        errors.add(:featured, "requires that review has been accepted by skanher for publication (publishable be true)")
      elsif confirmed_t_and_c == false
        errors.add(:feature, "requires that the terms and conditions acceptance have been accepted")
      elsif validated == false
        errors.add(:feature, "requires that the post has been reviewed and validated by the user (validated be true)")
      elsif ( title.nil? && comment.nil? )
        errors.add(:feature, "requires that the post has a title or a comment")
      end
    end
  end

  def self.answers
    joins(:answers)
  end

  def self.for_firm(firm_id)
    where(firm_id: firm_id)
  end

  def self.featured_for_firm(firm_id)
    where(firm_id: firm_id, featured: true)
  end

  def self.featured
    where(featured: true)
  end

  def self.featured_with_usernames_and_firm_names
    includes(:user, :firm).where(featured: true)
  end

  def self.featured_with_usernames
    joins(:user).where(featured: true)
  end

  def self.create_review_for_user(attributes)
    process_answers_attributes(attributes[:review_params][:answers_attributes])
    review = attributes[:user].review_portfolio.reviews.build(
      comment: attributes[:review_params][:comment],
      title: attributes[:review_params][:title],
      publishable: false,
      validated: false,
      featured: false,
      firm_id: attributes[:firm].id,
      user_firm_relationship: "Undefined",
      confirmed_t_and_c: attributes[:review_params][:confirmed_t_and_c],
      answers_attributes: @processed_answers_attributes,
      created_at_ip: attributes[:review_params][:created_at_ip]
      )
    review = review.save ? review : false
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

  private
    def self.process_answers_attributes(answers_attributes)
      @processed_answers_attributes = []
      for i in 1..5 do
        answer_hash = answers_attributes.fetch("#{i - 1}") { |el| {"user_rating"=>"0"} }
        answer_hash["test_id"] = "#{i}"
        @processed_answers_attributes << answer_hash
      end
    end

    def generate_token
      while Review.find_by_token(self.token).present? || self.token.blank?
        self.token = SecureRandom.uuid
      end
    end

    def switch_publishable_to_true
      if validated == true && comment.empty? && title.empty?
        self.publishable = true
      end
    end
end
