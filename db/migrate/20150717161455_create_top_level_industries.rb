class CreateTopLevelIndustries < ActiveRecord::Migration
  def change
    create_table :top_level_industries do |t|
      t.string :naf_code
      t.string :naf_title_fr
      t.string :naf_title_en

      t.timestamps null: false
    end
    add_index :top_level_industries, :naf_code
  end
end
