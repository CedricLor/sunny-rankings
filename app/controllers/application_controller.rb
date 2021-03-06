class ApplicationController < ActionController::Base
  ACCEPTED_LANGUAGES = "en fr"
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  config.embed_authenticity_token_in_remote_forms = true
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  def set_locale
    I18n.locale = params[:locale] || extract_locale_from_accept_language_header || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale == I18n.default_locale ? nil : I18n.locale }
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  def after_sign_in_path_for(resource)
    if current_user.has_pending_reviews
      reviews_path
    else
      root_path
    end
  end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password, profile_attributes: [:id, email_addresses_attributes: [:address, :id, :_destroy]]) }
    end

  private
    def extract_locale_from_accept_language_header
      if request.env['HTTP_ACCEPT_LANGUAGE']
        request.env['HTTP_ACCEPT_LANGUAGE'].scan(/[a-z]{2}/).each do | nav_language |
          return nav_language if ACCEPTED_LANGUAGES.include? nav_language
        end
      end
    end
end
