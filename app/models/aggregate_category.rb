class AggregateCategory
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :required, type: Boolean
  field :max_aggregates, type: Integer
  field :min_aggregates, type: Integer
  field :description, type: String

  embeds_many :aggregates

  validates :name, presence: true, length: {in: 2..20}

end
