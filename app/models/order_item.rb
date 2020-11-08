class OrderItem

  include Mongoid::Document
  include Mongoid::Timestamps

  field :aggregates, type: Array, default: []
  field :quantity, type: Integer, default: 0

  embeds_one :product
  belongs_to :order

  def get_total_price
    total = 0
    self.aggregates.each do |aggi|
      aggi["subvariants"].each do |sb|
        total = total + sb["price"]
      end
    end
    total = (self.product.price + total) * self.quantity
    total
  end

end
