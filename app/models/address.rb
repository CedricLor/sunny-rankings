class Address < ActiveRecord::Base
  has_and_belongs_to_many :firms

  geocoded_by :whole_address
  after_validation :geocode

  # reverse_geocoded_by :latitude, :longitude, :address => :addr_complement
  # after_validation :reverse_geocode

  def whole_address
    whole_address = "#{street} #{number}, #{city} #{zip_code}, #{country}"
  end
end
