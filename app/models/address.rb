class Address
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Geospatial
  Mapbox.access_token = "pk.eyJ1IjoiYW5keXJvaG0iLCJhIjoiY2p6NmRldzJjMGsyMzNpbjJ0YjZjZjV5NSJ9.SeHsvxUe4-pszVk0B4gRAQ"

  # before_validation :assign_data
  before_validation :update_old_records
  after_destroy :verify_last_default

  field :street, type: String
  field :city, type: String
  field :country, type: String
  field :location, type: Point
  field :default, type: Boolean, default: false
  field :external_number, type: String, default: ""
  field :internal_number, type: String

  embedded_in :model, polymorphic: true

  # TODO: Al actualizar de true a false o viceversa debemos verificar si hay alguna ya con default, entonces
  # TODO: se va a editar y pasar a false
  # TODO: Validaciones

  validates :street, presence: true, length: {in: 4..100}
  validates :default, presence: true, inclusion: {in: [true, false]}
  validates :external_number, presence: true, length: {in: 1..10}
  validates :internal_number, length: {in: 1..10}, allow_blank: true

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
    if self.default
      self.model.addresses.where(default: true, :id.ne => self.id).update_all(default: false)
    end
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
        return features.first["place_name"]
      rescue => e
        return nil
      end
    else
      return nil
    end
  end

end
