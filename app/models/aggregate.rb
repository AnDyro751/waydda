class Aggregate
  include Mongoid::Document
  include Mongoid::Timestamps

  before_validation :assign_created_at, on: :create
  # before_save :change_others_defaults

  # fields
  field :name, type: String
  field :price, type: Float, default: 0
  field :description, type: String
  field :default, type: Boolean, default: false
  field :add_to_price_product, type: Boolean, default: true

  # relations
  embedded_in :aggregate_category
  accepts_nested_attributes_for :aggregate_category, allow_destroy: true, :reject_if => :all_blank

  # validation
  # TODO: Add validations
  validates :name, presence: true, length: {in: 2..40}
  # validates :default, inclusion: {in: %w[true false]}

  # @param [Object] items
  def self.valid_elements(items:, required: true, aggregates:)
    new_items = []
    if items.kind_of?(Array)
      items.map do |aggc|
        if aggc.kind_of?(Hash)
          if aggc["id"].present? || aggc[:id].present?
            current_aggregate_id = aggc["id"] || aggc[:id]
            if required # TODO: Validar cuando las subvariantes no sean requeridas también
              if aggc["subvariants"].present? || aggc[:subvariants].present?
                current_subvariants = aggc["subvariants"] || aggc[:subvariants]
                current_aggc = AggregateCategory.get_record(id: current_aggregate_id, items: aggregates)
                logger.warn "El current id no es válido" if current_aggc.nil?
                return [] if current_aggc.nil?
                if AggregateCategory.valid_items_sale?(items: current_subvariants, current_aggregate: current_aggc)
                  current_subvariants.each do |sb|
                    if Aggregate.include_in_aggregate_category?(id: sb, aggregate_category: current_aggc)
                    else
                      logger.warn "Los aggregates no están incluidos en los params"
                      return []
                    end
                  end
                else
                  logger.warn "Los items no son válidos"
                  return []
                end
                logger.warn "Subvariantes -#{current_subvariants}"
              else
                logger.warn "El children no contiene subvariantes seleccionadas #{aggc[:subvariants]}-----#{aggc["subvariants"]}"
                return []
              end
            end
            new_items << aggc
          else
            logger.warn "El children no contiene un id"
            return []
          end
        else
          logger.warn "El children no es un Hash"
          return []
        end
      end
    else
      logger.warn "El parent no es un array"
    end
    logger.warn "NEW ITEMS #{new_items}"
    return new_items
  end


  def self.include_in_aggregate_category?(id:, aggregate_category:)
    in_category = false
    aggregate_category.aggregates.each { |agg| in_category = true if agg.id.to_s == id.to_s }
    logger.warn "Aggregate Category? #{!in_category.nil?}-#{id}"
    in_category
  end

  # Product.last.valid_aggregates_sale?(aggregates: [{id: "5f617f0beefc4101148764a7", subvariants: ["5f63d5e2eefc411d25c1e4f1"]},{id: "5f6187f5eefc4101148764a9", subvariants: ['5f626063eefc411d0455e0dc']}])

  # @param [ArrayField] ids
  # @return [ArrayField]
  def self.get_valid_ids_in_aggregates(ids: [], aggregates: [])
    ids.select { |id| aggregates.include?(id) }
  end

  private

  def change_others_defaults
    if self.default
      self.product.aggregates.where(:id.nin => [self.id], default: true)
    end
  end


  def assign_created_at
    self.created_at = Time.now
    self.updated_at = Time.now
  end


end
