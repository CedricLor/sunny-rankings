class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable #, :validatable

  has_one :profile, dependent: :destroy
  has_one :review_portfolio, dependent: :destroy

  ###############
  has_many :email_addresses, through: :profile, dependent: :destroy
  # after_commit :save_default_email

  has_one :default_email, through: :profile, class_name: "EmailAddress"
  validates :default_email, presence: true
  default_scope { includes :default_email }
  ###############

  validates_associated :email_addresses, :default_email, :profile

  has_many :reviews, through: :review_portfolio, dependent: :destroy
  has_many :answers, through: :reviews, dependent: :destroy

  before_create :create_unique_username
  after_create :save_additional_stack
  before_update :validate_additional_emails_and_save_if_valid

  accepts_nested_attributes_for :email_addresses, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :profile, allow_destroy: true

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      joins(:email_addresses).where(conditions).where(["username = :value OR lower(email_addresses.address) = lower(:value)", { :value => login }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end

  def self.find_by_email(email)
    joins(:email_addresses).where("email_addresses.address = ?", email).first
  end

  def self.find_or_create_by_email(attributes)
    user = find_by_email(attributes[:email])
    if user.nil?
      user = create(
        email: attributes[:email],
        validated: false)
    else
      user
    end
  end

  def email
    default_email.address rescue nil
  end

  def email= email
    self.default_email = email_addresses.where(address: email).first_or_initialize
  end

  def email_changed?
    self.profile.default_email_id_changed?
  end
  ################################
  # new function to set the password without knowing the current password used in our confirmation controller.
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end
  # new function to return whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end
  # new function to provide access to protected method unless_confirmed
  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end
  def password_required?
  # Password is required if it is being set, but not for new records
    if !persisted?
      false
    else
      !password.nil? || !password_confirmation.nil?
    end
  end

  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
    password == password_confirmation && !password.blank?
  end
  ################################
  def pending_reviews
    reviews.where(validated: false)
  end

  def validated_reviews
    reviews.where(validated: true)
  end

  def validated_but_not_agreed_for_publication_reviews
    reviews.where(validated: true, agreed_for_publication: false)
  end

  def validated_but_not_agreed_for_publication_reviews_with_answers_and_test_names_for_publication
    validated_but_not_agreed_for_publication_reviews.includes(answers: [:test]).order(updated_at: :desc)
  end

  def agreed_for_publication_reviews
    reviews.where(agreed_for_publication: true)
  end

  def pending_publication_reviews
    reviews.where(agreed_for_publication: true, publishable: false)
  end

  def effectively_published_reviews
    reviews.where(agreed_for_publication: true, publishable: true)
  end

  def has_pending_reviews
    pending_reviews.count > 0
  end
  ################################
  def number_of_reviews
    reviews.count
  end

  def number_of_pending_reviews
    pending_reviews.count
  end

  def number_of_validated_reviews
    validated_reviews.count
  end

  def number_of_agreed_for_publication_reviews
    agreed_for_publication_reviews.count
  end

  def number_of_reviews_pending_publication
    pending_publication_reviews.count
  end

  def number_of_effectively_published_reviews
    effectively_published_reviews.count
  end
  ################################
  def pending_reviews_for_firm(firm)
    pending_reviews.where(firm_id: firm.id)
    # reviews.where(firm_id: firm.id, validated: false)
  end

  def pending_review_for_firm(firm)
    pending_reviews_for_firm(firm).last
  end

  def potentially_publishable_reviews_for_firm(firm)
    reviews.where(firm_id: firm.id, agreed_for_publication: false)
  end

  def potentially_publishable_review_for_firm(firm)
    reviews.where(firm_id: firm.id, agreed_for_publication: false).last
  end
  ################################

  protected

    def validate_additional_emails_and_save_if_valid
      email_addresses.each { | email_address | email_address.save if email_address.valid? }
    end

    # def update_default_email
    #   puts "*" * 40
    #   puts "in update_default_email"
    #   puts "self.default_email"
    #   de = self.default_email
    #   de.save!
    # end

    def save_default_email
      if default_email.user.blank?
        default_email.profile = self.profile
      elsif default_email.user != self
        raise Exceptions::EmailConflict
      end
      de = self.default_email
      de.save!
    end

    def create_unique_username
      while User.find_by_username(self.username).present? || self.username.blank?
        self.username = Faker::Internet.user_name(%w(. _ -)) + "_" + Faker::Internet.user_name(%w(. _ -))
      end
    end

    def save_additional_stack
      self.default_email.profile_id = self.profile.id
      self.default_email.save!
      self.create_review_portfolio
    end
end
