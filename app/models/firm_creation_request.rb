class FirmCreationRequest < ActiveRecord::Base
  belongs_to :requested_firm
  belongs_to :user
end
