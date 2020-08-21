class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :total_products, type: Integer, default: 0
  field :photo, type: String, default: "places/default.png"
  # relations
  belongs_to :place
  has_many :products


  # @param [Integer] quantity
  # @param [Boolean] plus {true: +, false: - }
  def update_products_counter(quantity, plus)
    oper = plus ? self.total_products + quantity : self.total_products - quantity
    self.update(total_products: oper)
  end

end
