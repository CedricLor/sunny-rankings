class CreateFirmAddresses < ActiveRecord::Migration
  def change
    create_table :firm_addresses do |t|
      t.references :firm, index: true, foreign_key: true
      t.references :address, index: true, foreign_key: true
      t.string :type_of_address

      t.timestamps null: false
    end
  end
end
