class AddConnexionDataToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :created_at_ip, :string
    add_column :reviews, :updated_at_ip, :string
  end
end
