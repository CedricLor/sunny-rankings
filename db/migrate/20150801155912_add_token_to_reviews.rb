class AddTokenToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :token, :string, null: true, default: ""
  end
end
