class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.x.mail.info
  default bcc: Rails.configuration.x.mail.bcc
  layout "mailer"
end
