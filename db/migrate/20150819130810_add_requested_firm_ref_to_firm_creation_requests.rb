class AddRequestedFirmRefToFirmCreationRequests < ActiveRecord::Migration
  def change
    add_reference :firm_creation_requests, :requested_firm, index: true, foreign_key: true
  end
end
