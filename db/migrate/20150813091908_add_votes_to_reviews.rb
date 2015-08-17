class AddVotesToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :down_votes, :integer, default: 0
    add_column :reviews, :up_votes, :integer, default: 0
  end
end
