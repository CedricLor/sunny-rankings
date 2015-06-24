class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :firm
  has_many :answers
end
