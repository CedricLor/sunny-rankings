class Address < ActiveRecord::Base
  has_many :firm_addresses
  has_many :firms, through: :firm_addresses

  geocoded_by :whole_address
  after_validation :geocode, if: Proc.new { |address| address.latitude.nil? || address.longitude.nil? }

  validates :city, presence: :true, format: { with: /\A[A-Z][a-zéèêëöîA-Z\-]{1}[a-zéèêëöîA-Z\-' ]+[a-zéèêëöî]\z/ }

  reverse_geocoded_by :latitude, :longitude do |obj,results|
    if geo = results.first
      obj.city    = geo.city
      obj.zip_code = geo.postal_code
      obj.country = geo.country_code
      obj.street = geo.route
      obj.number = geo.street_number
    end
  end
  after_validation :reverse_geocode, unless: Proc.new { |address| address.country.match(/\A[A-Z]{2}\z/) }

  before_save :has_unique_coordinates?

  def whole_address
    "#{street} #{number} #{addr_complement}, #{city} #{zip_code}, #{country}"
  end

  def self.save_or_retrieve_addresses_and_return_firm_addresses_hash(params)
    params[:firm_addresses_attributes] = []
    params[:addresses_attributes].each do | address_hash |
      create_firm_address_attribute_from_address_attribute(address_hash, params)
    end
    params.delete(:addresses_attributes)
    params
  end

  # def self.call_create
  #   params = {}
  #   params[:addresses_attributes] = [
  #     {city: "Bruxelles", country: "Belgium", street: "Place Sainte-Gudule", number: "5", zip_code: "B-1000"},
  #     {city: "Paris", country: "France", street: "Passage Lathuille", number: "2", zip_code: "75018"},
  #     {city: "Paris", country: "France", street: "Avenue de Clichy", number: "20", zip_code: "75018"}
  #   ]
  #   save_or_retrieve_addresses_and_return_firm_addresses_hash(params)
  #   byebug
  # end

  private

  def self.create_firm_address_attribute_from_address_attribute(address_hash, params)
    if geosearch_result = geocode_address_hash(address_hash).first
      address = find_by_coordinates_or_create_by_address(geosearch_result)
      params[:firm_addresses_attributes] << {address_id: address.id}
    end
  end

  def self.geocode_address_hash(address_hash)
    Geocoder.search("
      #{address_hash[:street]}
      #{address_hash[:number]},
      #{address_hash[:zip_code]}
      #{address_hash[:city]},
      #{address_hash[:country]},
      #{address_hash[:fuzzy_address]}
      ")
  end

  def self.find_by_coordinates_or_create_by_address(geosearch_result)
    addr = fetch_by_coordinates(geosearch_result.latitude, geosearch_result.longitude)
    addr.nil? ? create_with_geosearch_results(geosearch_result) : addr
  end

  def self.create_with_geosearch_results(geosearch_result)
    create({
      city: geosearch_result.city,
      zip_code: geosearch_result.postal_code,
      country: geosearch_result.country_code,
      street: geosearch_result.route,
      number: geosearch_result.street_number,
      latitude: geosearch_result.latitude,
      longitude: geosearch_result.longitude
      })
  end

  def self.fetch_by_coordinates(latitude, longitude)
    where(
      latitude: "#{latitude}",
      longitude: "#{longitude}")
      .first
  end

  def self.already_exist_by_coordinates?(latitude, longitude)
    where(
      latitude: latitude,
      longitude: longitude)
      .length >= 1
  end

  def combined_coordinates
    "#{latitude}, #{longitude}"
  end

  def has_unique_coordinates?
    if Address.where(latitude: "#{latitude}", longitude: "#{longitude}").length >= 1
      puts ("*" * 40)
      p self
      puts "is already in the database and will not be saved again."
      puts ("*" * 40)
      false
    else
      true
    end
  end
end
