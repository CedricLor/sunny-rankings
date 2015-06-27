class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.string :test_question
      t.string :test_long_question
      t.string :select_options

      t.timestamps null: false
    end
  end
end
