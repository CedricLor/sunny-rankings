class FirmAddress < ActiveRecord::Base
  belongs_to :firm, inverse_of: :firm_addresses
  belongs_to :address, inverse_of: :firm_addresses

  # validates :firm_id, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  # validates :address_id, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
end
