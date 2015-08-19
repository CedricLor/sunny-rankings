class AddUserRefToFirmCreationRequests < ActiveRecord::Migration
  def change
    add_reference :firm_creation_requests, :user, index: true, foreign_key: true, null: true
  end
end
