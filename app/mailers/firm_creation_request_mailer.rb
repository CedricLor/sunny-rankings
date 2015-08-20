class FirmCreationRequestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.review_mailer.new_review.subject
  #
  def new_firm_creation_request_for(usermail, requested_firm)
    @usermail = usermail
    @requested_firm = requested_firm

    mail to: @usermail, subject: t('new_firm_creation_request_for_loggedin_user_subject', default: "Thank you for requesting the creation of a new file for #{@requested_firm.name}")
  end

  def new_firm_creation_request_with_your_email(usermail, requested_firm)
    @usermail = usermail
    @requested_firm = requested_firm

    mail to: @usermail, subject: t('new_firm_creation_request_with_usermail_unloggedin_subject', default: "A request for the creation of a file for #{@requested_firm.name} has been made with your email")
  end
end
