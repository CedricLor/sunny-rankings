class Profile < ActiveRecord::Base
  belongs_to :user
  has_many :reviews, through: :users, autosave: :true
  has_many :answers, through: :reviews, autosave: :true
  accepts_nested_attributes_for :reviews
  accepts_nested_attributes_for :answers

  validates :real_email, presence: true
  validates :real_email, uniqueness: {
    case_sensitive: false,
    message: "You already have a profile. Please login or request a reset email if you have lost your connection credentials."
  }
  validates :first_name, presence: true, on: :update
  validates :last_name, presence: true, on: :update
  validates :country, presence: true, on: :update
  validates :phone_number, presence: true, on: :update
  validates :phone_number, uniqueness: {
    case_sensitive: false,
    message: "You already have a profile. Please login or request a reset email if you have lost your connection credentials."
  }, on: :update
  validates :gender, presence: true, on: :update
  validates :gender, inclusion: {
    in: %w(male female transgenre other none Male Female Transgenre Other None m f t M F T),
    message: "%{value} is not a valid gender. You may choose between Female, Male, Transgenre, Other or None."
    }, on: :update
  validates :age, presence: true, on: :update
  validates :age, numericality: {
    only_integer: true,
    message: "%{value} must be an integer."
  }, on: :update
  validates :age, numericality: {
    greater_than_or_equal_to: 16,
    message: "You must be over 16 to vote."
  }, on: :update

  validates_each :first_name, :last_name do |record, attr, value|
    record.errors.add(attr, 'must start with upper case') if value =~ /\A[[:lower:]]/
  end

  validates_associated :reviews
end

  # t.string :first_name
  # t.string :last_name
  # t.string :phone_number
  # t.string :country
  # t.integer :age
  # t.string :gender
  # t.string :real_email

  # t.string :employer_name
  # t.string :current_position
  # t.string :address
  # t.string :mother_maiden_name
  # t.boolean :validated

  # t.boolean :first_time_login_upon_firm_review
