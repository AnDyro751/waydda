class OrderMailer < ApplicationMailer

  default :from => "jcarmona16@alumnos.uaq.mx"


  def new_order(order, admin)
    @order = order
    @admin = admin
    mail(:to => @admin.email ? @admin.email : "angelmendezz751@gmail.com",
         :subject => '¡Nueva orden!')
  end

end
