class EmailAddress < ActiveRecord::Base
  belongs_to :profile
  belongs_to :user
  # delegate :user, to: :profile

  validates :address, presence: true
  validates :address, uniqueness: {
    case_sensitive: false,
    message: "You already have a profile. Please login or request a reset email if you have lost your connection credentials."
  }
  validates :address, email: {:strict_mode => true}
end
