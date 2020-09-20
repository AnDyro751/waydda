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
  validates :name, presence: true, length: {in: 2..50}

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
    items.map { |aggc| aggc.kind_of?(Hash) ? aggc[:id] || aggc["id"] : aggc.id.to_s }
  end

  # @param [ArrayField] aggregate_categories
  # @return [ArrayField]
  def self.get_all_aggregates(aggregate_categories:)
    new_aggregates = []
    aggregate_categories.each do |aggc|
      aggc.aggregates.each do |agg|
        new_aggregates << agg
      end
    end
    new_aggregates
  end


  def self.valid_items_sale?(items:, current_aggregate:)
    if current_aggregate.multiple_selection and items.length >= 1
      return true
    end
    if !current_aggregate.multiple_selection and items.length > 1
      logger.warn "Se mandaron más de un elemento cuando solo se debío mandar uno"
      return false
    else
      return true
    end
  end

  def self.get_record(id:, items:)
    items.to_a.find { |it| it.id.to_s == id }
  end

  def self.get_records_by_ids(ids:, product:)
    new_records = []
    # aggregate_ids = AggregateCategory.get_ids(items: product.aggregate_categories)

    product.aggregate_categories.select { |aggc| aggc }

  end


end
