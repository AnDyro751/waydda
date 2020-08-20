class Viewer
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :model, polymorphic: true
end
