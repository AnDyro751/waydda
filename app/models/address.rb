class Address
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Geospatial

  field :street, type: String
  field :city, type: String
  field :country, type: String
  field :location, type: Point
  field :default, type: Boolean, default: false

  embedded_in :user

  # TODO: Al actualizar de true a false o viceversa debemos verificar si hay alguna ya con default, entonces
  # TODO: se va a editar y pasar a false

end
