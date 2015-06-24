class Answer < ActiveRecord::Base
  belongs_to :review
  belongs_to :test
end
