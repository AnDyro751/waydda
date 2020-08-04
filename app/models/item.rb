class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  # relations
  belongs_to :place
    # TODO: Uncomment product relationship

    #has_many :products
end
