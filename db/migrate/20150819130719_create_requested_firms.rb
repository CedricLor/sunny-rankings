class CreateRequestedFirms < ActiveRecord::Migration
  def change
    create_table :requested_firms do |t|
      t.string :name
      t.integer :number_of_requests

      t.timestamps null: false
    end
  end
end
