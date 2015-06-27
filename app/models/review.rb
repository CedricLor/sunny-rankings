class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :firm
  has_many :answers
  accepts_nested_attributes_for :answers
end
