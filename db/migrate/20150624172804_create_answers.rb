class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :user_rating
      t.boolean :reviewed_by_user, default: false
      t.references :review, index: true, foreign_key: true
      t.references :test, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
