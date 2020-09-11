class Item
  include Mongoid::Document
  include Mongoid::Timestamps
  include GlobalID::Identification

  field :name, type: String
  field :total_products, type: Integer, default: 0
  field :photo, type: String, default: "places/default.png"
  field :description, type: String
  # relations
  belongs_to :place
  has_and_belongs_to_many :products


  # @param [Integer] quantity
  # @param [Boolean] plus {true: +, false: - }
  def update_products_counter(quantity, plus)
    oper = plus ? self.total_products + quantity : self.total_products - quantity
    self.update(total_products: oper)
  end

end
