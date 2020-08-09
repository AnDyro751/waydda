class Cart
  include Mongoid::Document
  include Mongoid::Timestamps
  field :quantity, type: Integer, default: 0
  has_many :cart_items
  belongs_to :user
end
