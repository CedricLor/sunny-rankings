class AddMetricsToFirms < ActiveRecord::Migration
  def change
    add_column :firms, :number_of_researches, :integer
    add_column :firms, :number_of_views, :integer
  end
end
