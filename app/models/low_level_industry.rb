class LowLevelIndustry < ActiveRecord::Base
  belongs_to :top_level_industry, inverse_of: :low_level_industries
  has_many :firms, foreign_key: :naf_code, primary_key: :naf_code, inverse_of: :low_level_industry
  validates :top_level_industry, presence: true
  validates :naf_code, presence: true, uniqueness: true, length: { is: 5 }
  validates :naf_title_fr, presence: true, uniqueness: true
  validates :naf_title_en, presence: true, uniqueness: true
end

