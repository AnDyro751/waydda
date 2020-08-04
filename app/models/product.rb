class Product
  #fields
  field :name, type: String
  field :description, type: String
  field :price, type: Float
  field :aggregates_required, type: Integer, default: 0
  field :max_aggregates, type: Integer, default: 1
  field :photo, type: String, default: "places/default.png"
  #relations
  belongs_to :item
end
