class UpdateViewCounterJob < ApplicationJob
  queue_as :default

  def perform(model)
    model.update(last_viewed: Time.now.to_datetime)
    # Do something later
  end
end
