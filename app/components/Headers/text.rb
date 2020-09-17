class Headers::Text < ViewComponent::Base
  # @param [TrueClass] with_margin
  def initialize(title:, small: false, subtitle: nil, with_margin: true, link: nil, font: nil, with_border: true, padding_class: nil)
    @title = title
    @small = small
    @subtitle = subtitle
    @with_margin = with_margin
    @link = link
    @font = font
    @with_border = with_border
    @padding_class = padding_class
  end
end