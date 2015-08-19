class RemoveEmailFromFirmCreationRequests < ActiveRecord::Migration
  def change
    remove_column :firm_creation_requests, :email, :string
  end
end
