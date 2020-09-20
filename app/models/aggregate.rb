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
  def self.valid_elements(items:, required: true)
    new_items = []
    if items.kind_of?(Array)
      items.map do |aggc|
        if aggc.kind_of?(Hash)
          if aggc["id"].present? || aggc[:id].present?
            if required
              if aggc["subvariants"].present? || aggc[:subvariants].present?
                current_subvariants = aggc["subvariants"] || aggc[:subvariants]
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
