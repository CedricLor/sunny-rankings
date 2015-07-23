class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def welcome(user)
    @user = user
    @greeting = "Hi"

    mail(to: @user.email, subject: 'Welcome to Skanher')
    # TO DO: Replace @user.email by correct email
  end

  def new_user_on_vote(email)
    mail(to: email, subject: "Please confirm your vote on Skanher")
  end
end
