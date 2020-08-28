ActionMailer::Base.smtp_settings = {
    :user_name => 'apikey', #waydda_key
    :password => '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',
    :domain => 'yourdomain.com',
    :address => 'smtp.sendgrid.net',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
}