class Headers::Text < ViewComponent::Base
  # @param [TrueClass] with_margin
  def initialize(title:, small: false, subtitle: nil, with_margin: true, link: nil, font: nil)
    @title = title
    @small = small
    @subtitle = subtitle
    @with_margin = with_margin
    @link = link
    @font = font
  end
end