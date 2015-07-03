class Firm < ActiveRecord::Base
  has_many :reviews
  has_many :answers, through: :reviews
  has_many :granted_awards
  has_many :awards, through: :granted_awards

  def self.ranking
    all.sort_by{ |f| f.avg_rating * -1 }
    # Firm.ranking.map(&:name)
    # Firm.ranking.map(&:avg_rating)
  end

  def self.ranking_by_industry(industry)
    all.where(industry: industry).sort_by{ |f| f.avg_rating * -1 }
  end

  # The following two methods provide the @competitors variable to the competitors partial
  def self.top10_by_industry_by_country(industry, country)
    top_by_industry_by_country = all.where(industry: industry, country: country).sort_by{ |f| f.avg_rating * -1 }
    top_by_industry_by_country = top_by_industry_by_country[0..9]
  end

  def self.top10_by_country(country)
    top_by_country = all.where(country: country).sort_by{ |f| f.avg_rating * -1 }
    top_by_country = top_by_country[0..9]
  end

  def current_reporting_period_average_for_test(test_id)
    answers.current_reporting_period.where(test_id: test_id).average(:user_rating).to_f
  end

  def overall_current_reporting_period_average
      answers.current_reporting_period.average(:user_rating).to_f
  end
  # This is the method
  def current_reporting_period_averages
    answers.current_reporting_period.group(:test_id).average(:user_rating)
  end

  def previous_reporting_period_average_for_test(test_id)
    answers.previous_reporting_period.where(test_id: test_id).average(:user_rating).to_f
  end

  def overall_previous_reporting_period_average
      answers.previous_reporting_period.average(:user_rating).to_f
  end

  def previous_reporting_period_averages
    answers.previous_reporting_period.group(:test_id).average(:user_rating)
  end

  def current_trend
    if current_reporting_period_average > previous_reporting_period_average
      return "positive"
    elsif current_reporting_period_average < previous_reporting_period_average
      return "negative"
    else
      return "neutral"
    end
  end

  def ranking
    Firm.ranking.index { |f| f.id == id } + 1
  end

  def avg_rating
    answers.average(:user_rating).to_f
  end

  def avg_ratings_by_test
    answers.group(:test_id).average(:user_rating)
  end

  def number_of_reviews
    reviews.count
  end

  def number_of_valid_reviews
    reviews.where(validated: true).count
  end

  def number_of_pending_reviews
    reviews.where(validated: true).count
  end
end