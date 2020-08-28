class UserNotifierMailer < ApplicationMailer

  # TODO: Agregar valores reales

  def send_signup_email
    headers "X-SMTPAPI" => {
        "sub": {
            "%name%" => ["amazoncrema@gmail.com"]
        },
        "filters": {
            "templates": {
                "settings": {
                    "enable": 1,
                    "template_id": 'f52f8084-3376-4df8-99ea-4502317010d2'
                }
            }
        }
    }.to_json
    mail(:to => "amazoncrema@gmail.com",
         :subject => 'Waydda - Registro exitoso')
  end

end
