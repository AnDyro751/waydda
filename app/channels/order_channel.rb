class OrderChannel < ApplicationCable::Channel
  def subscribed
    if current_user.current_place
      stream_from "#{current_user.current_place.id.to_s}_place"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
