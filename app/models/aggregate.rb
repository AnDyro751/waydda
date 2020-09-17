class Aggregate
  include Mongoid::Document
  include Mongoid::Timestamps

  before_validation :assign_created_at, on: :create
  # before_save :change_others_defaults

  # fields
  field :name, type: String
  field :price, type: Float
  field :description, type: String
  field :default, type: Boolean, default: false
  field :add_to_price_product, type: Boolean, default: true

  # relations
  embedded_in :aggregate_category
  accepts_nested_attributes_for :aggregate_category, allow_destroy: true, :reject_if => :all_blank

  # validation
  # TODO: Add validations
  validates :name, presence: true, length: {in: 2..40}
  validates :price, presence: true
  # validates :default, inclusion: {in: %w[true false]}

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
