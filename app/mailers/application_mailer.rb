class ApplicationMailer < ActionMailer::Base
  default from: "cedric.lor@gmail.com"
  # TO DO: Validate with coach (Lien, Xavier or Simon)
  layout 'mailer'
end
