class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :profile
  has_one :review_portfolio

  ###############
  has_many :email_addresses, through: :profile, dependent: :destroy, autosave: true
  after_commit :save_default_email

  has_one :default_email, through: :profile, class_name: "EmailAddress"
  # validates :default_email, presence: true
  default_scope { includes :default_email }
  ###############

  has_many :reviews, through: :review_portfolio
  has_many :answers, through: :reviews

  before_create :create_unique_credentials
  after_validation :store_email
  after_create :create_additional_stack

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["username = :value OR lower(email) = lower(:value)", { :value => login }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end

  def self.find_by_email_address(email)
    joins(:profile).joins(:email_addresses).where("email_addresses.address = ?", email)
  end

  ###############################
  def email_address
    default_email.address rescue nil
    # profile.email rescue nil
  end

  def email_address= email
    if EmailAddress.new(address: email).valid?
      self.default_email = email_addresses.where(address: email).first_or_initialize
      self.default_email.profile_id = self.profile.id
      self.default_email
    elsif email_addresses.where(address: email).first
      self.default_email = email_addresses.where(address: email).first
    else
      raise Exceptions::EmailConflict
    end
  end
  ################################

  protected
    def save_default_email
      if default_email.user.blank?
        default_email.profile = self.profile
      elsif default_email.user != self
        raise Exceptions::EmailConflict
      end
      de = self.default_email
      de.save!
    end

    def create_unique_credentials
      # self.email = create_unique_email
      self.username = create_unique_username
    end

    def create_unique_email
      email = Faker::Internet.email
      while User.find_by_email(email).present?
        email = Faker::Internet.email
      end
      email
    end

    def create_unique_username
      username = Faker::Internet.user_name(%w(. _ -))
      while User.find_by_username(username).present?
        username = Faker::Internet.user_name(%w(. _ -))
      end
      username
    end

    def store_email
      @stored_email = self.email
    end

    def create_additional_stack
      self.create_profile(email: @stored_email)
      self.create_review_portfolio
    end
end
