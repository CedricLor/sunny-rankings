class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable #, :validatable

  has_one :profile, dependent: :destroy
  has_one :review_portfolio, dependent: :destroy
  has_many :reviews, through: :review_portfolio, dependent: :destroy
  has_many :answers, through: :reviews, dependent: :destroy
  has_many :firms, through: :reviews

  ###############
  has_many :email_addresses, through: :profile, dependent: :destroy
  # after_commit :save_default_email

  has_one :default_email, through: :profile, class_name: "EmailAddress"
  validates :default_email, presence: true
  default_scope { includes :default_email, :profile, :review_portfolio, :answers, :reviews, :firms }
  ###############

  validates_associated :email_addresses, :default_email


  before_create :create_unique_username
  after_create :save_additional_stack

  # after_initialize { byebug }
  # before_validation { byebug }
  # after_validation { byebug }
  # before_create { byebug}
  # after_create { byebug }

  accepts_nested_attributes_for :email_addresses, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :profile, allow_destroy: true

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login, :is_new_user_created_on_vote

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
        validated: false,
        is_new_user_created_on_vote: true)
    else
      user
      user.is_new_user_created_on_vote = false
    end
    user
  end

  def email
    # byebug
    default_email.address rescue nil
  end

  def email= email
    # byebug
    self.default_email = email_addresses.where(address: email).first_or_initialize unless self.default_email && self.default_email.address == email
  end

  def email_changed?
    # byebug
    if self.profile
      self.profile.email_changed?
    elsif self.default_email
      self.default_email.address_changed?
    end
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
  def number_of_reviews
    reviews.count
  end
  ################################
  def pending_reviews
    reviews.where(validated: false)
  end

  def number_of_pending_reviews
    pending_reviews.count
  end

  def has_pending_reviews
    number_of_pending_reviews > 0
  end
  #*************
  def validated_reviews
    reviews.where(validated: true)
  end

  def number_of_validated_reviews
    validated_reviews.count
  end
  #*************
  def pending_publication_reviews
    reviews.where(validated: true, publishable: false)
  end

  def number_of_reviews_pending_publication
    pending_publication_reviews.count
  end
  #*************
  def effectively_published_reviews
    reviews.where(validated: true, publishable: true)
  end

  def number_of_effectively_published_reviews
    effectively_published_reviews.count
  end
  ################################
  def pending_reviews_for_firm(firm)
    pending_reviews.where(firm_id: firm.id)
  end

  def pending_review_for_firm(firm)
    pending_reviews_for_firm(firm).last
  end

  def potentially_publishable_reviews_for_firm(firm)
    reviews.where(firm_id: firm.id, validated: false)
  end

  def potentially_publishable_review_for_firm(firm)
    reviews.where(firm_id: firm.id, validated: false).last
  end
  ################################

  protected
    def create_unique_username
      # byebug
      while User.find_by_username(self.username).present? || self.username.blank?
        self.username = Faker::Internet.user_name(%w(. _ -)) + "_" + Faker::Internet.user_name(%w(. _ -))
      end
    end

    def save_additional_stack
      # byebug
      self.default_email.profile_id = self.profile.id
      self.default_email.save!
      # byebug
      self.create_review_portfolio
    end
end
