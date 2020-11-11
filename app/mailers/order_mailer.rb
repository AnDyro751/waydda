class OrderMailer < ApplicationMailer

  default :from => "jcarmona16@alumnos.uaq.mx"


  def new_order(order, admin)
    @order = order
    @admin = admin
    mail(:to => @admin.email ? @admin.email : "angelmendezz751@gmail.com",
         :subject => '¡Nueva orden!')
  end

  # @param [Object] order
  def customer_order_received(order:)
    @order = order
    mail(:to => "angelmendezz751@gmail.com",
         :subject => 'Tu compra en Waydda México')
  end


  # @param [Object] order
  def customer_order_process(order:)
    @order = order
    mail(:to => "angelmendezz751@gmail.com",
         :subject => 'Tu compra en Waydda México está siendo procesada')
  end

  # @param [Object] order
  def customer_order_cancelled(order:)
    @order = order
    mail(:to => "angelmendezz751@gmail.com",
         :subject => 'Compra cancelada. Waydda México.')
  end

  def customer_order_send(order:)
    @order = order
    mail(:to => "angelmendezz751@gmail.com",
         :subject => "Tu pedido ha sido enviado"
    )
  end

end
