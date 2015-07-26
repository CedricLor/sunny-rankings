class CreateTopLevelIndustries < ActiveRecord::Migration
  def change
    create_table :top_level_industries do |t|
      t.string :naf_code, null: false, unique: true
      t.string :naf_title_fr
      t.string :naf_title_en

      t.timestamps null: false
    end
    add_index :top_level_industries, :naf_code, unique: true
  end
end
