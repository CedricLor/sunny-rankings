class Profile < ActiveRecord::Base
  has_many :users
  has_many :reviews, through: :users
  has_many :answers, through: :reviews, autosave: :true
end