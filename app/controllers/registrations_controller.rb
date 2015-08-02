# app/controllers/confirmations_controller.rb
class RegistrationsController < Devise::RegistrationsController

  def create
    # byebug
    if user = User.find_by_email(sign_up_params[:email])
      UserMailer.attempt_to_sign_up_with(user, sign_up_params[:email]).deliver_now
      flash[:notice] = t('signed_up_but_unconfirmed', scope: [:devise, :registrations], default: "A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.")
      redirect_to root_path
    else
      super
    end
  end
end