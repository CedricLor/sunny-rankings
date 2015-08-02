class Profile < ActiveRecord::Base
  belongs_to :user

  has_one :review_portfolio, through: :user
  has_many :reviews, through: :review_portfolio
  has_many :answers, through: :reviews

  ###############
  has_many :email_addresses, dependent: :destroy
  after_create :save_default_email

  belongs_to :default_email, class_name: "EmailAddress"
  # validates :default_email, presence: true
  default_scope { includes :default_email }
  ###############

  # validates :user, presence: true

  validates :first_name, presence: true, on: :update, unless: :non_sensitive
  validates :last_name, presence: true, on: :update, unless: :non_sensitive
  validates :country, presence: true, on: :update, unless: :non_sensitive

  validates :phone_number, presence: true, on: :update, unless: :non_sensitive
  validates :phone_number, uniqueness: {
    case_sensitive: false,
    message: "You already have a profile. Please login or request a reset email if you have lost your connection credentials."
  }, on: :update, unless: :non_sensitive

  validates :gender, presence: true, on: :update, unless: :non_sensitive
  validates :gender, inclusion: {
    in: %w(male female transgenre other none Male Female Transgenre Other None m f t M F T),
    message: "%{value} is not a valid gender. You may choose between Female, Male, Transgenre, Other or None."
    }, on: :update, unless: :non_sensitive

  validates :age, presence: true, on: :update, unless: :non_sensitive
  validates :age, numericality: {
    only_integer: true,
    message: "%{value} must be an integer."
  }, on: :update, unless: :non_sensitive
  validates :age, numericality: {
    greater_than_or_equal_to: 16,
    message: "You must be over 16 to vote."
  }, on: :update, unless: :non_sensitive

  validates_each :first_name, :last_name do |record, attr, value|
    record.errors.add(attr, 'must start with upper case') if value =~ /\A[[:lower:]]/
  end

  accepts_nested_attributes_for :email_addresses, reject_if: :all_blank, allow_destroy: true

  # after_initialize { byebug }
  # before_validation { byebug }
  # after_validation { byebug }
  # before_create { byebug}
  # after_create { byebug }

  ###############################
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
    self.default_email_id_changed? || self.default_email.address_changed?
  end

  private
    def save_default_email
      if default_email.profile.blank?
        default_email.profile = self
      elsif default_email.profile != self
        raise Exceptions::EmailConflict
      end
      default_email.save!
    end

    def non_sensitive
      # TO DO: User other criteria to require the validations
      if user.validated == false
        true
      else
        false
      end
    end
end

  # t.string :first_name
  # t.string :last_name
  # t.string :phone_number
  # t.string :country
  # t.integer :age
  # t.string :gender

  # t.string :employer_name
  # t.string :current_position
  # t.string :address
  # t.string :mother_maiden_name
  # t.boolean :validated
