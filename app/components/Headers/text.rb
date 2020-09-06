class Headers::Text < ViewComponent::Base
  def initialize(title:, small: false, subtitle:)
    @title = title
    @small = small
    @subtitle = subtitle
  end
end