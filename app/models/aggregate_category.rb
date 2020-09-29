class AggregateCategory
  include Mongoid::Document
  include Mongoid::Timestamps
  include GlobalID::Identification

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


  def self.get_all_aggregate_categories_and_aggregates(aggregates:, product:)
    all_aggregates = []
    aggregate_categories_ids = []
    aggregate_category_subvariant_ids = []
    aggregates.each do |aggid|
      aggregate_categories_ids << aggid["id"]
      aggregate_category_subvariant_ids += aggid["subvariants"]
    end
    aggregate_category_subvariant_ids.uniq!

    current_aggregate_categories = AggregateCategory.get_by_ids(ids: aggregate_categories_ids, items: product.aggregate_categories)
    current_aggregate_categories.each do |aggc|
      new_subvariants = []
      aggc.aggregates.each do |sub|
        if aggregate_category_subvariant_ids.include?(sub.id.to_s)
          new_subvariants << sub.attributes.slice(:name, :price, :description, :_id)
        end
      end
      all_aggregates << {aggregate_category: aggc.attributes.slice(:name, :description, :_id), subvariants: new_subvariants}
    end
    return all_aggregates
  end

  def self.get_by_ids(ids:, items:)
    all_ids = []
    items.each do |aggc|
      if ids.include?(aggc.id.to_s)
        all_ids << aggc
      end
    end
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
    current_record = nil
    items.to_a.each do |it|
      logger.warn "----ITEM #{it.id.to_s} --- #{id}"
      current_record = it if it.id.to_s == id
    end
    current_record
  end

  def self.get_records_by_ids(ids:, product:)
    new_records = []
    # aggregate_ids = AggregateCategory.get_ids(items: product.aggregate_categories)

    product.aggregate_categories.select { |aggc| aggc }

  end


end
