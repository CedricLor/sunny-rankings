class Profile < ActiveRecord::Base
  has_many :users
  has_many :reviews, through: :users, autosave: :true
  has_many :answers, through: :reviews, autosave: :true
  accepts_nested_attributes_for :reviews
  accepts_nested_attributes_for :answers
end
