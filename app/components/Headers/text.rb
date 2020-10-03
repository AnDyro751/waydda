class Headers::Text < ViewComponent::Base
  # @param [TrueClass] with_margin
  def initialize(title:, small: false, subtitle: nil, with_margin: true, link: nil, font: nil, with_border: true, padding_class: nil, id: "", with_background: false)
    @title = title
    @small = small
    @subtitle = subtitle
    @with_margin = with_margin
    @link = link
    @font = font
    @with_border = with_border
    @padding_class = padding_class
    @id = id
    @with_background = with_background
  end
end