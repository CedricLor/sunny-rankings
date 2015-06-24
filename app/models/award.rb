class Award < ActiveRecord::Base
  has_many :granted_awards
end
