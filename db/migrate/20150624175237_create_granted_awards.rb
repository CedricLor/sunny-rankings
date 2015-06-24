class CreateGrantedAwards < ActiveRecord::Migration
  def change
    create_table :granted_awards do |t|
      t.references :award, index: true, foreign_key: true
      t.references :firm, index: true, foreign_key: true
      t.text :details

      t.timestamps null: false
    end
  end
end
