class Aggregate
  include Mongoid::Document
  include Mongoid::Timestamps

  before_save :change_others_defaults

  # fields
  field :name, type: String
  field :price, type: Float
  field :description, type: String
  field :default, type: Boolean, default: false
  field :add_to_price_product, type: Boolean, default: true

  # relations
  embedded_in :aggregate_category
  # validation
  # TODO: Add validations
  validates :name, presence: true, length: {in: 2..40}
  validates :price, presence: true
  validates :default, inclusion: {in: %w[true false]}

  private

  def change_others_defaults
    if self.default
      self.product.aggregates.where(:id.nin => [self.id], default: true)
    end
  end


end
