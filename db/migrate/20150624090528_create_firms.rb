class CreateFirms < ActiveRecord::Migration
  def change
    create_table :firms do |t|
      t.string :name
      t.string :url
      t.string :address
      t.string :country
      t.integer :headcount
      t.text :business_description
      t.string :industry
      t.string :icon_name

      t.timestamps null: false
    end
  end
end
