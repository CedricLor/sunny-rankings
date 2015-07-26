class CreateLowLevelIndustries < ActiveRecord::Migration
  def change
    create_table :low_level_industries do |t|
      t.string :naf_code, null: false, unique: true
      t.string :naf_title_fr
      t.string :naf_title_en
      t.references :top_level_industry

      t.timestamps null: false
    end
    add_index :low_level_industries, :naf_code, unique: true
  end
end
