class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.belongs_to :user, index: true
      t.string :first_name
      t.string :last_name
      t.string :mother_maiden_name
      t.string :address
      t.string :phone_number
      t.string :country
      t.string :employer_name
      t.string :current_position
      t.integer :age
      t.string :gender
      t.string :real_email
      t.boolean :validated

      # Preparing the creation of a profile model
      # t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
