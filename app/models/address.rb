class Address
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Geospatial
  # includes ActiveModel::Validations

  Mapbox.access_token = "pk.eyJ1IjoiYW5keXJvaG0iLCJhIjoiY2p6NmRldzJjMGsyMzNpbjJ0YjZjZjV5NSJ9.SeHsvxUe4-pszVk0B4gRAQ"

  # before_validation :assign_data
  before_validation :update_old_records
  after_destroy :verify_last_default

  field :address, type: String
  field :city, type: String
  field :country, type: String
  field :location, type: Point
  field :default, type: Boolean, default: false
  field :description, type: String, default: ""
  field :internal_number, type: String
  field :current, type: Boolean, default: true
  field :lat, type: Float
  field :lng, type: Float

  embedded_in :model, polymorphic: true

  # TODO: Al actualizar de true a false o viceversa debemos verificar si hay alguna ya con default, entonces
  # TODO: se va a editar y pasar a false
  # TODO: Validaciones

  validates :address, presence: true, length: {in: 4..100}
  validates :default, presence: true, inclusion: {in: [true, false]}
  validates :description, presence: true, length: {in: 1..25}
  validates :internal_number, length: {in: 1..10}, allow_blank: true
  validates :lat, presence: true
  validates :lng, presence: true
  validate :coordinated_validation
  # validates_with CoordinatesValidator

  def coordinated_validation
    if lat.present? && lng.present?
      # Hacer la petición a mapbox
      Address.current_available?([lat, lng], ["MX-MEX", "MX-DIF"])

    else
      errors.add(:lng, "Can't be blank")
      errors.add(:lat, "Can't be blank")
    end
  end


  private

  # def assign_data
  #   if self.location_changed?
  #     self.street = Address.get_data(self.location.to_a)
  #   end
  # end

  def verify_last_default
    addresses = self.model.addresses
    if addresses.length > 0
      addresses.first.update(default: true)
    end
  end

  def update_old_records
    if self.current
      self.model.addresses.where(current: true, :id.ne => self.id).update_all(current: false)
    end
  end

  # @return [Boolean] is available?
  # @param [Array [lng,lat]] location
  # @param [Array] location
  def self.current_available?(search_param, location)
    return false unless location.kind_of?(Array)
    placenames = Mapbox::Geocoder
                     .geocode_reverse({
                                          "latitude": search_param[1],
                                          "longitude": search_param[0],
                                          limit: 1
                                      })
    return false if placenames.first.nil?
    features = placenames.first["features"]
    str = features.first["context"].find { |el| el["id"].include?("region") }
    if str
      return location.any? { |word| str["short_code"].include?(word) }
    else
      return false
    end
    return false
  end

  # @param [Array or String] search_param
  # @return [String] street
  def self.get_data(search_param)
    placenames = Mapbox::Geocoder
                     .geocode_reverse({
                                          "latitude": search_param[1],
                                          "longitude": search_param[0],
                                          limit: 1
                                      })
    if placenames.first
      features = placenames.first["features"]
      begin
        puts features.first["context"]
        return features.first["place_name"]
      rescue => e
        return nil
      end
    else
      return nil
    end
  end

end
