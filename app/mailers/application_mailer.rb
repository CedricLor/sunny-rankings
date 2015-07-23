class ApplicationMailer < ActionMailer::Base
  default from: "cedric@skanher.se"
  # TO DO: Validate with coach (Lien, Xavier or Simon)
  layout 'mailer'
end
