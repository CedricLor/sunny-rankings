class RemoveUselessFieldsFromFirmCreationRequests < ActiveRecord::Migration
  def change
    remove_column :firm_creation_requests, :name, :string
    remove_column :firm_creation_requests, :number_of_requests, :integer
  end
end
