class AggregateCategory
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :required, type: Boolean, default: false
  field :multiple_selection, type: Boolean, default: false
  field :description, type: String, default: ""

  embeds_many :aggregates
  embedded_in :product

  accepts_nested_attributes_for :aggregates, allow_destroy: true, :reject_if => :all_blank
  validates :name, presence: true, length: {in: 2..20}

  def self.get_all_valid(items:, all:)
    all_ids = all.map { |aggc| aggc.id.to_s }
    all_ids - items
  end

  def self.get_required(items:)
    items.select { |agg| agg.required }
  end

  # @param [ArrayField] items
  # @return [ArrayField]
  def self.get_ids(items:)
    items.map { |aggc| aggc.id.to_s }
  end

  def self.get_aggregate_ids(aggregate_categories:)
    aggregate_categories.each { |aggc| aggc.aggregates.map { |agg| agg.id.to_s } }
  end

end
