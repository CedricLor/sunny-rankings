class ReviewMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.review_mailer.new_review.subject
  #
  def first_review_for(usermail, firm)
    @usermail = usermail
    @firm = firm

    mail to: @usermail, subject: t('first_review_subject', default: 'Congratulations and thank you! This is your first review on skanher')
  end

  def new_review_for(usermail, firm)
    @usermail = usermail
    @firm = firm

    mail to: @usermail, subject: t('new_review_for_loggedin_user_subject', default: 'Thank you for your new review on skanher')
  end

  def new_review_with_your_email(usermail, firm)
    @usermail = usermail
    @firm = firm

    mail to: @usermail, subject: t('new_review_with_usermail_unloggedin_subject', default: 'A new review has been created with your email')
  end
end
