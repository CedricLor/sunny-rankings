class FirmMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.firm_mailer.new_review.subject
  #
  def request_new_firm(firm_name, country_name, city_name)
    @firm_name = firm_name
    @country_name = country_name

    mail to: 'cedric@skanher.se', subject: "Quelqu'un a demandé l'ajout d'une nouvelle entreprise"
  end
end
