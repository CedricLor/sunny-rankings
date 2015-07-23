class CreateFirms < ActiveRecord::Migration
  def change
    create_table :firms do |t|
      t.string :name
      t.string :url
      t.string :country
      t.integer :headcount
      t.text :business_description
      t.string :industry
      t.string :icon_name
      t.string :reg_number

      t.timestamps null: false
    end
  end
end
