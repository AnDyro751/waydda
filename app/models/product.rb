class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Geospatial
  include Mongoid::Slug
  after_create :update_counters
  #fields
  field :name, type: String
  field :description, type: String
  field :price, type: Float
  field :aggregates_required, type: Integer, default: 0
  field :max_aggregates, type: Integer, default: 1
  field :photo, type: String, default: "places/default.png"
  slug :name
  #relations
  belongs_to :item
  belongs_to :place

  private
  def update_counters
    self.place.update_products_counter(1,true)
  end
end
