class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
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
      t.boolean :first_time_login_upon_firm_review

      # Preparing the creation of a profile model
      t.references :user, index: true, foreign_key: true
      # t.integer :profile_id

      t.timestamps null: false
    end
  end
end
