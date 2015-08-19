class FirmCreationRequestsController < ApplicationController

  def create
    if FirmMailer.request_new_firm(firm_creation_request_params[:name], firm_creation_request_params[:country_of_firm], firm_creation_request_params[:city_of_firm]).deliver_now
      # set_flash_variables("Your request to add \"#{params[:firm_name]}\" was received by our services. We are currently processing it.", "notice")
      set_flash_variables(flash_message_selector(:firm_addition_request_success))
    else
      # set_flash_variables("Your request to add \"#{params[:firm_name]}\" could not be sent to our services. Please try again later.", "alert")
      set_flash_variables(flash_message_selector(:firm_addition_request_failure))
    end
    ajax_or_html_response_for_request_firm_addition
  end

  private
    ################################
    # general helpers
    def firm_creation_request_params
      params.require(:firm_creation_request).permit(:name, :country_of_firm, :city_of_firm, :email)
    end
    # "firm_creation_request"=>{"name"=>"tooot", "country_of_firm"=>"", "city_of_firm"=>"", "email"=>"annemarie@yahoo.fr"}

    ################################
    # request firm addition helpers methods
    def flash_message_selector(flash_request)
      flash_messages = {
        firm_addition_request_success: {
          flash_message: t(
            'firm_addition_request_success',
            scope: [:controllers, :firms, :flash_message_selector],
            firm_name: firm_creation_request_params[:name],
            default: "Your request to add \"#{firm_creation_request_params[:name]}\" was received by our services. We are currently processing it."
            ),
          flash_type: "notice"
          },
        firm_addition_request_failure: {
          flash_message: t(
            'firm_addition_request_failure',
            scope: [:controllers, :firms, :flash_message_selector],
            firm_name: firm_creation_request_params[:name],
            default: "Your request to add \"#{firm_creation_request_params[:name]}\" could not be sent to our services. Please try again later."
            ),
          flash_type: "alert"
        }
      }
      flash_messages[flash_request]
    end

    def set_flash_variables(flash_variables_hash)
      @flash_text = flash_variables_hash[:flash_message]
      @flash_type = flash_variables_hash[:flash_type]
    end

    def request_firm_addition_redirect_helper(flash)
      redirect_to firms_path
    end

    def ajax_or_html_response_for_request_firm_addition
      respond_to do |format|
        format.html { request_firm_addition_redirect_helper(flash[@flash_type] = @flash_text) }
        format.js
      end
    end
end