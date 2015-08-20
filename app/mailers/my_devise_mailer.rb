class MyDeviseMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views
  def confirmation_instructions(record, token, opts={})
    if record.reviews.present?
      @firm = record.reviews.last.firm
    elsif record.firm_creation_requests.present?
      @requested_firm = record.firm_creation_requests.last.requested_firm
    end
    super
  end
end