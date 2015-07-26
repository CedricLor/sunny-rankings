class ReviewPortfolio < ActiveRecord::Base
  belongs_to :user

  has_many :reviews, autosave: :true
  has_many :answers, through: :reviews, autosave: :true

  accepts_nested_attributes_for :reviews
  accepts_nested_attributes_for :answers

  validates :user, presence: true

  validates_associated :reviews
end
