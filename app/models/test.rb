class Test < ActiveRecord::Base
  has_many :answers, inverse_of: :test
end
