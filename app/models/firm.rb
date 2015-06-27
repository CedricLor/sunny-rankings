class Firm < ActiveRecord::Base
  has_many :reviews
  has_many :answers, through: :reviews
  has_many :granted_awards

  def self.ranking
    all.sort_by{ |f| f.avg_rating * -1 }
    # Firm.ranking.map(&:name)
    # Firm.ranking.map(&:avg_rating)
  end

  def self.ranking_by_industry(industry)
    all.where(industry: industry).sort_by{ |f| f.avg_rating * -1 }
  end

  def ranking
    Firm.ranking.index { |f| f.id == id } + 1
  end

  def avg_rating
    answers.average(:user_rating).to_f
  end

  def avg_ratings_by_test
    # former avg_answer_ratings
    answers.group(:test_id).average(:user_rating)
  end

  def number_of_reviews
    reviews.count
  end
end
