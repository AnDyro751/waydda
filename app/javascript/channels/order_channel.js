import consumer from "./consumer"

consumer.subscriptions.create("OrderChannel", {
  connected() {
    console.log("CONNECT")
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    console.log("DISCONNECT")
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log(data)
    if(data.model_type === "place"){
      if(data.action_type === "connect"){
        console.log("VAMOS A ACTUALIZAR CONNECT")
      }
    }
    // Called when there's incoming data on the websocket for this channel
  }
});
