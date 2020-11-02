# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
    :user_name => 'jcarmona16@alumnos.uaq.mx',
    :password => '6Zn!+6hCE9D.Gc!6Zn!+6hCE9D.Gc!',
    :address => 'smtp.sendgrid.net',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
}