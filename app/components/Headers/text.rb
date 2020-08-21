class Headers::Text < ViewComponent::Base
  def initialize(title:, small: false)
    @title = title
    @small = small
  end
end