class Award < ActiveRecord::Base
  has_many :granted_awards, inverse_of: :award
end
