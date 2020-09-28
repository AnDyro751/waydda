class SendWhatsAppMessageJob < ApplicationJob
  queue_as :default

  def perform(message:, phone:)
    account_sid = 'AC8d9e9b1bf0fb4d44fa7fbfc14ebdbe5d'
    auth_token = 'd710c52aed85cfb45d30e8c2b7bc5f95'
    @client = Twilio::REST::Client.new(account_sid, auth_token)
    begin
      message_send = @client.messages.create(
          body: message,
          from: 'whatsapp:+14155238886',
          to: "whatsapp:+521#{phone}"
      )
      puts "MENSAGE ENVIADO #{message_send}"
      return true
    rescue => e
      puts "-------------_#{e}"
      logger.warn "ERROR AL ENVIAR WHATSAPP #{e}"
      return false
    end
  end
end
