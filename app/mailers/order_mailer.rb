class OrderMailer < ApplicationMailer

  default :from => "jcarmona16@alumnos.uaq.mx"


  def new_order(order, admin)
    @order = order
    @admin = admin
    mail(:to => @admin.email ? @admin.email : "angelmendezz751@gmail.com",
         :subject => '¡Nueva orden!')
  end

  def customer_order_received(order:)
    @order = order
    mail(:to => "angelmendezz751@gmail.com",
         :subject => 'Tu compra en Waydda México')
  end

end
