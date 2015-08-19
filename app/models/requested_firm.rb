class RequestedFirm < ActiveRecord::Base
  has_many :firm_creation_requests
end
