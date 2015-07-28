class AddCommentsToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :comment, :text
    add_column :reviews, :title, :string, limit: 255
    add_column :reviews, :agreed_for_publication, :boolean, null: false, default: false
    add_column :reviews, :publishable, :boolean, null: false, default: false
  end
end
