class CreateOrderJob < ApplicationJob
  queue_as :default

  def perform(address, current_user, cart)
    # Do something later
  end
end
