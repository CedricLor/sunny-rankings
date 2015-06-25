class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :user, index: true, foreign_key: true
      t.references :firm, index: true, foreign_key: true
      t.string :user_firm_relationship
      t.boolean :validated

      t.timestamps null: false
    end
  end
end
