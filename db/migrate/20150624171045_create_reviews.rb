class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :user, index: true, foreign_key: true
      t.references :firm, index: true, foreign_key: true
      t.string :user_firm_relationship
      t.boolean :confirmed_t_and_c, default: false
      t.boolean :validated, default: false

      t.timestamps null: false
    end
  end
end
