class GrantedAward < ActiveRecord::Base
  belongs_to :award, inverse_of: :granted_awards
  belongs_to :firm, inverse_of: :granted_awards
end
