class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :city
      t.string :street
      t.string :number
      t.string :zip_code
      t.string :country
      t.string :addr_complement
      t.string :fuzzy_address

      t.timestamps null: false
    end
  end
end
