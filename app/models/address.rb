class Address
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Geospatial
  include GlobalID::Identification

  # includes ActiveModel::Validations

  Mapbox.access_token = "pk.eyJ1IjoiYW5keXJvaG0iLCJhIjoiY2p6NmRldzJjMGsyMzNpbjJ0YjZjZjV5NSJ9.SeHsvxUe4-pszVk0B4gRAQ"

  # before_validation :assign_data
  # before_validation :update_old_records
  after_destroy :verify_last_default

  field :address, type: String
  field :city, type: String
  field :country, type: String
  field :location, type: Point
  field :default, type: Boolean, default: false
  field :description, type: String, default: ""
  field :internal_number, type: String
  field :current, type: Boolean, default: false
  field :lat, type: Float
  field :lng, type: Float
  field :instructions, type: String

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
      response = Address.current_available?([lng, lat], %w[mx])
      unless response
        errors.add(:lng, "Los valores son incorrectos")
        errors.add(:lat, "Los valores son incorrectos")
      end
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
                                          "longitude": search_param[0],
                                          "latitude": search_param[1],
                                          limit: 1
                                      })
    return false if placenames.first.nil?
    features = placenames.first["features"]
    if features.length > 0
      # TODO: Buscar en region y en place
      place = features.first["context"].find { |el| el["id"].include?("country") }

      if place
        if place["short_code"]
          str = place
        else
          return false
        end
      else
        return false
      end
    else
      return false
    end
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
                                          "longitude": search_param[0],
                                          "latitude": search_param[1],
                                          limit: 1
                                      })
    if placenames.first
      features = placenames.first["features"]
      begin
        return features.first["place_name"]
      rescue => e
        return nil
      end
    else
      return nil
    end
  end

end
