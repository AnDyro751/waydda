class Pricing::ItemFeature::Index < ViewComponent::Base
  def initialize(text:, available: false, soon: false)
    @text = text
    @available = available
    @soon = soon
  end
end