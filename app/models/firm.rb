class Firm < ActiveRecord::Base
  has_many :reviews
  has_many :answers, through: :reviews

  has_many :granted_awards
  has_many :awards, through: :granted_awards

  belongs_to :low_level_industry, foreign_key: :naf_code, primary_key: :naf_code, inverse_of: :firms

  has_many :firm_addresses
  has_many :addresses, through: :firm_addresses

  accepts_nested_attributes_for :reviews
  accepts_nested_attributes_for :answers
  accepts_nested_attributes_for :addresses
  accepts_nested_attributes_for :firm_addresses

  validates_associated :addresses
  # I think this one is looping around with the addresses one
  # validates_associated :firm_addresses
  validates :country, presence: :true, format: { with: /\A[A-Z][a-zA-Z\-]{3}[a-zA-Z\-' ]+[a-z]\z/ }
  # To re-instate once I will have found the reg number of the French firms already in the database
  # validates :reg_number, presence: :true, if: Proc.new { | firm | firm.country == ("France" || "FR") }
  validates :naf_code, presence: :true, format: { with: /\A[0-9]{4}[A-Z]\z/ }, if: Proc.new { | firm | firm.country == ("France" || "FR") }
  validates :name, presence: :true
  validates :headcount, presence: :true, numericality: true

  def self.create_with_addresses(params)
    params = Address.save_or_retrieve_addresses_and_return_firm_addresses_hash(params)
    create(params)
  end

  def add_addresses(params)
    params = Address.save_or_retrieve_addresses_and_return_firm_addresses_hash(params)
    self.update(params)
  end

  # def self.my_update_test
  #   params = {
  #     addresses_attributes: [
  #       {fuzzy_address: "5 rue de Mesnilmontant, Paris, France"},
  #       {fuzzy_address: "3 place Bellecourt, Lyon, France"}
  #     ]
  #   }
  #   Firm.find_by_name("Crédit Foncier").add_addresses(params)
  # end

  def self.ranking
    all.sort_by{ |f| f.avg_rating * -1 }
    # Firm.ranking.map(&:name)
    # Firm.ranking.map(&:avg_rating)
  end

  def self.ranking_by_industry(industry)
    all.where(industry: industry).sort_by{ |f| f.avg_rating * -1 }
  end

  def self.ranking_by_country(country)
    all.where(country: country).sort_by{ |f| f.avg_rating * -1 }
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
    answers.validated.current_reporting_period.where(test_id: test_id).average(:user_rating).to_f
  end

  def overall_current_reporting_period_average
    answers.validated.current_reporting_period.average(:user_rating).to_f
  end
  # This is the method
  def current_reporting_period_averages
    answers.validated.current_reporting_period.group(:test_id).average(:user_rating)
  end

  def previous_reporting_period_average_for_test(test_id)
    answers.validated.previous_reporting_period.where(test_id: test_id).average(:user_rating).to_f
  end

  def overall_previous_reporting_period_average
      answers.validated.previous_reporting_period.average(:user_rating).to_f
  end

  def previous_reporting_period_averages
    answers.validated.previous_reporting_period.group(:test_id).average(:user_rating)
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

  def ranking_by_country(country)
    Firm.ranking_by_country(country).index { |f| f.id == id } + 1
  end

  def avg_rating
    answers.validated.average(:user_rating).to_f
  end

  def avg_ratings_by_test
    answers.validated.group(:test_id).average(:user_rating)
  end

  def total_by_test
    answers.validated.group(:test_id).sum(:user_rating)
  end

  def answers_count_by_test
    answers.validated.group(:test_id).count
  end

  def number_of_reviews
    reviews.count
  end

  def valid_reviews
    reviews.where(validated: true)
  end

  def number_of_valid_reviews
    valid_reviews.count
  end

  def number_of_pending_reviews
    reviews.where(validated: false).count
  end

  def valid_and_publishable_reviews
    valid_reviews.where(publishable: true)
  end

  def number_of_valid_and_publishable_reviews
    valid_and_publishable_reviews.count
  end

  def ordered_reviews_with_answers_test_names_and_usernames_for_publication
    valid_and_publishable_reviews.includes(review_portfolio: [:user], answers: [:test]).order(updated_at: :desc)
  end

  def awards_names
    awards.map(&:name)
  end

  def featured_reviews
  end
end
