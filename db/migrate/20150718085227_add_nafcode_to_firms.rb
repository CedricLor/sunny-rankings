class AddNafcodeToFirms < ActiveRecord::Migration
  def change
    add_column :firms, :naf_code, :string
    add_index :firms, :naf_code
    add_foreign_key :firms, :low_level_industries, name: :naf_code, column: :naf_code, primary_key: :naf_code
    # column makes references to the name of the column in the firms table
    # primary_key makes references to the name of the column in the low_level_industries table
  end
end
