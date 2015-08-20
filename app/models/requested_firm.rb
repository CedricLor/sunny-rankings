class RequestedFirm < ActiveRecord::Base
  has_many :firm_creation_requests
  accepts_nested_attributes_for :firm_creation_requests
end
