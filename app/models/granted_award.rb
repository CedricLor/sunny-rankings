class GrantedAward < ActiveRecord::Base
  belongs_to :award
  belongs_to :firm
end
