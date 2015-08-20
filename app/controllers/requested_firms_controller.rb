class RequestedFirmsController < ApplicationController

  def update
    redirect_to firms_path and return if form_has_errors?
    if update_actions
      set_flash_variables(flash_message_selector(:firm_addition_request_success))
      send_mail_to_user if @user
    else
      set_flash_variables(flash_message_selector(:firm_addition_request_failure))
    end
    ajax_or_html_response_for_request_firm_addition
  end

# I. User block handling: Check whether the user has provided an email
  # A. If so
    # 1. Check whether the user is connected OR the email corresponds to a user
    # 2. If so, pass the user to the FirmCreationRequest object ## This will be done below (III. A.)
    # 3. Else:
      # a. create a user and pass it to the FirmCreationRequest object
      # b. differ sending the email
  # B. Else do not associate any email to the firm creation request
# II. RequestedFirm block handling:
  # A. Check whether the firm name provided by the user corresponds to an existing RequestedFirm or create a new if not
  # B. In all cases, pass the RequestedFirm to the FirmCreationRequest object
# III. FirmCreationRequest object handling
  # A. Collect all the data from the form to create the FirmCreationRequest object
  # B. Save the FirmCreationRequest object
# IV. Communication
  # C. User email communication if email has been provided
    # 1. If a new user has been created, send a combined email (email validation and FirmCreationRequest object creation)
    # 2. If no new user has been created, send an email for the FirmCreationRequest object
  # D. Set the flash variables
  # E. Redirect


  # create_table "firm_creation_requests", force: :cascade do |t|
  #   t.string   "country_of_requester"
  #   t.string   "city_of_requester"
  #   t.string   "country_of_firm"
  #   t.string   "city_of_firm"
  #   t.datetime "created_at",           null: false
  #   t.datetime "updated_at",           null: false
  #   t.integer  "user_id"
  #   t.integer  "requested_firm_id"
  # end

  # add_index "firm_creation_requests", ["requested_firm_id"], name: "index_firm_creation_requests_on_requested_firm_id", using: :btree
  # add_index "firm_creation_requests", ["user_id"], name: "index_firm_creation_requests_on_user_id", using: :btree

  # create_table "requested_firms", force: :cascade do |t|
  #   t.string   "name"
  #   t.integer  "number_of_requests"
  #   t.datetime "created_at",         null: false
  #   t.datetime "updated_at",         null: false
  # end


  private
    ################################
    # general helpers
    def requested_firm_params
      params.require(:requested_firm).permit(:name, firm_creation_request: [:country_of_firm, :city_of_firm])
    end

    ################################
    # create helpers methods
    ################
    # controller level validations for create method
    def has_firm_name
      if requested_firm_params[:name] == ""
        flash[:alert] = t(
            :invalid_firm_name,
            scope: [:controllers, :firm_creation_requests, :create],
            default: "Please indicate a firm name! "
            )
        @has_errors = true
      end
    end
    # TODO: change the scope in the i18n in the has_valid_email method
    def has_valid_email
      unless EmailValidator.valid?(params[:email])
        flash[:alert] = t(
            :invalid_email,
            scope: [:controllers, :reviews, :create],
            default: "Please indicate a valid email address! "
            )
        @has_errors = true
      end
    end

    def form_has_errors?
      @has_errors = false
      has_firm_name
      has_valid_email unless params[:email].nil? || params[:email] == ""
      @has_errors
    end
    ################
    # user handling block of the create method
    def set_user
      user_signed_in? ? @user = current_user : @user = User.find_or_create_by_email(email: params[:email])
    end

    def user_handling
      set_user unless params[:email] == ""
    end
    ################
    # requested firm handling block of the create method
    def set_requested_firm
      @requested_firm = RequestedFirm.find(params[:id])
    end

    def requested_firm_handling
      set_requested_firm
      @requested_firm.update({name: requested_firm_params[:name]}) unless @requested_firm.name == requested_firm_params[:name]
    end
    ################
    # requested firm handling block of the create method
    def firm_creation_request_handling
      @requested_firm.firm_creation_requests.create(
        user_id: @user ? @user.id : nil,
        country_of_requester: request.location.country_code,
        city_of_requester: request.location.city,
        country_of_firm: requested_firm_params[firm_creation_request:[:country_of_firm]],
        city_of_firm: requested_firm_params[firm_creation_request:[:city_of_firm]]
        )
    end
    ################
    # create method call to ActionMailer
    def send_mail_to_user
      if user_signed_in?
        FirmCreationRequestMailer.new_firm_creation_request_for(@user.email, @requested_firm).deliver_now
      else
        @user.is_new_user_created_on_process ? @user.send_confirmation_instructions : FirmCreationRequestMailer.new_firm_creation_request_with_your_email(params[:email], @requested_firm).deliver_now
      end
    end

    ################
    # final actions of the create method
    def flash_message_selector(flash_request)
      flash_messages = {
        firm_addition_request_success: {
          flash_message: t(
            'firm_addition_request_success',
            scope: [:controllers, :firms, :flash_message_selector],
            firm_name: requested_firm_params[:name],
            default: "Your request to add \"#{requested_firm_params[:name]}\" was received by our services. We are currently processing it."
            ),
          flash_type: "notice"
          },
        firm_addition_request_failure: {
          flash_message: t(
            'firm_addition_request_failure',
            scope: [:controllers, :firms, :flash_message_selector],
            firm_name: requested_firm_params[:name],
            default: "Your request to add \"#{requested_firm_params[:name]}\" could not be sent to our services. Please try again later."
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

    def update_actions
      user_handling
      requested_firm_handling
      firm_creation_request_handling
      FirmMailer.request_new_firm(requested_firm_params[:name], requested_firm_params[firm_creation_request:[:country_of_firm]], requested_firm_params[firm_creation_request:[:city_of_firm]]).deliver_now
    end
end