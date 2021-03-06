class EmailAddress < ActiveRecord::Base
  belongs_to :profile
  belongs_to :user
  # delegate :user, to: :profile

  validates :address, presence: true
  validates :address, email: {
    strict_mode: true,
    message: "is not a valid email address"
  }

  # after_initialize { byebug }
  # before_validation { byebug }
  # after_validation { byebug }
  # before_create { byebug}
  # after_create { byebug }
end
