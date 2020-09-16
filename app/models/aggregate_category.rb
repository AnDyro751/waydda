class AggregateCategory
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :required, type: Boolean, default: false
  field :multiple_selection, type: Boolean, default: false
  field :description, type: String, default: ""

  embeds_many :aggregates
  accepts_nested_attributes_for :aggregates, allow_destroy: true

  embedded_in :product
  validates :name, presence: true, length: {in: 2..20}

end
