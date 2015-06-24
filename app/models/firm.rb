class Firm < ActiveRecord::Base
  has_many :reviews
  has_many :granted_awards
end
