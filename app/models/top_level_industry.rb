class TopLevelIndustry < ActiveRecord::Base
  has_many :low_level_industries, inverse_of: :top_level_industry, autosave: :true
  accepts_nested_attributes_for :low_level_industries, allow_destroy: true
  validates_associated :low_level_industries
  validates :naf_code, presence: true, uniqueness: true, length: { maximum: 2 }
  validates :naf_title_fr, presence: true, uniqueness: true
  validates :naf_title_en, presence: true, uniqueness: true
end
