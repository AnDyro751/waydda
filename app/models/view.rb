class View
  include Mongoid::Document
  include Mongoid::Timestamps
  field :total, type: Integer, default: 0
  field :month, type: String, default: 1
  field :year, type: String, default: 2020

  belongs_to :model, polymorphic: true
end
