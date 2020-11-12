class Utils::LongDistance < ViewComponent::Base
  # @param [String] message
  def initialize(size: false, message: "Tu dirección actual está demasiado lejos de este lugar")
    @size = size
    @message = message
  end
end