class ChangeMetricColumnsOfFirms < ActiveRecord::Migration
  Firm.all.update_all number_of_researches: 0
  Firm.all.update_all number_of_views: 0
  def change
    change_column_null :firms, :number_of_researches, false
    change_column_default :firms, :number_of_researches, to: 0
    change_column_null :firms, :number_of_views, false
    change_column_default :firms, :number_of_views, to: 0
  end
end
