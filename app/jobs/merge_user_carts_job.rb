class MergeUserCartsJob < ApplicationJob
  queue_as :default

  def perform(guest_user, current_user)
    User.logging_in(guest_user, current_user)
    # Do something later
  end
end
