class ApplicationMailer < ActionMailer::Base
  default from: ENV["SMTP_FROM"]
  layout 'mailer'
end
