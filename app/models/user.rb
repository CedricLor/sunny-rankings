class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_one :profile
  has_one :review_portfolio

  ###############
  has_many :email_addresses, through: :profile, dependent: :destroy
  # after_commit :save_default_email

  has_one :default_email, through: :profile, class_name: "EmailAddress"
  # validates :default_email, presence: true
  default_scope { includes :default_email }
  ###############

  has_many :reviews, through: :review_portfolio
  has_many :answers, through: :reviews

  before_create :create_unique_username
  before_save :validate_email_or_exit
  after_create :save_additional_stack
  before_update :validate_additional_emails_and_save_if_valid

  accepts_nested_attributes_for :email_addresses, reject_if: :all_blank, allow_destroy: true

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

  def self.find_by_email_address(email)
    joins(:email_addresses).where("email_addresses.address = ?", email).first
  end

  def self.find_or_create_by_email_address(attributes)
    user = find_by_email_address(attributes[:email])
    if user.nil?
      user = create(
        email: attributes[:email],
        password: attributes[:password].nil? ? "password" : attributes[:password],
        password_confirmation: attributes[:password].nil? ? "password" : attributes[:password],
        validated: false)
    else
      user
    end
  end

  def email
    puts "*" * 40
    puts "in email"
    default_email.address rescue nil
  end

  def email= email
    puts "*" * 40
    puts "in email= email"
    if self.default_email.nil?
      self.default_email = email_addresses.where(address: email).first_or_initialize
    else
      self.default_email.address = email
    end
  end

  def email_changed?
    puts "*" * 40
    puts "in email changed?"
    self.profile.default_email_id_changed?
  end
  ################################

  protected
    def validate_email_or_exit
      self.default_email.valid?
    end

    def validate_additional_emails_and_save_if_valid
      email_addresses.each { | email_address | email_address.save if email_address.id.nil? && email_address.valid? }
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
      username = Faker::Internet.user_name(%w(. _ -))
      while User.find_by_username(username).present?
        username = Faker::Internet.user_name(%w(. _ -))
      end
      username
    end

    def save_additional_stack
      self.default_email.profile_id = self.profile.id
      self.default_email.save!
      self.create_review_portfolio
    end
end
