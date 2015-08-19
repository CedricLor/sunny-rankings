class CreateFirmCreationRequests < ActiveRecord::Migration
  def change
    create_table :firm_creation_requests do |t|
      t.string :name
      t.string :email
      t.integer :number_of_requests
      t.string :country_of_requester
      t.string :city_of_requester
      t.string :country_of_firm
      t.string :city_of_firm

      t.timestamps null: false
    end
  end
end
# changes and connection to other tables
# a firm creation request:
# - always belongs to a requested firm (to be created)
# - may belong to a user (if user is logged in or if the user provides an email)
# ----------
# a user_id (foreign_key to user table) will be added
# email will be transfered to the user_id reference
# ----------
# a requested firm table should be created
# name, number of requests, country_of_firm and city_of_firm should be transfered to requested firm