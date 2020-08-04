class Business
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Geospatial
  field :name, type: String
  field :address, type: String
  field :slug, type: String
  field :status, type: String
  field :coordinates, type: Point
  belongs_to :user
end
