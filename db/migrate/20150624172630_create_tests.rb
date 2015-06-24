class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.string :test_question

      t.timestamps null: false
    end
  end
end
