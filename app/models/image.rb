class Image
  include Mongoid::Document
  include Mongoid::Timestamps
  field :url, type: String, default: "places/default.png"

  embedded_in :model, polymorphic: true
end
