class FirmsController < ApplicationController
  before_action :set_firm, only: [:show ]

  def index
    set_user if user_signed_in?
    set_location
    set_first_hit_tracker
    set_firms_list_on_search_results_or_country_index
  end

  def geosearch
    look_up_closest_addresses_and_set_closest_firm
    redirect_to(@firms.empty? ? firms_path : firm_path(@firms.first))
  end

  def show
    select_pending_review_for_this_firm_if_any
    @number_of_accounted_firm_reviews = @firm.number_of_valid_and_publishable_reviews
    set_variables_for_ratings_and_trends
    @competitors = Firm.top10_by_industry_by_country(@firm.industry, @firm.country)
    build_review_form
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def request_firm_addition
    if FirmMailer.request_new_firm(params[:firm_name], request.location.country, request.location.city).deliver_now
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
    # general purposes helpers methods
    def firms_params
      params.require(:firm).permit(:name, :address, :country, :headcount, :business_description, :business_sector, :icon_name)
    end

    def set_firm
      @firm = Firm.find(params[:id])
    end

    def set_user
      @user = current_user
    end
    ################################
    # index helpers methods
    def get_location
      if request.location.country == "Reserved"
        @user_ip_country = "France"
        session[:geoloc_by_ip_has_failed] = true
      else
        @user_ip_country = request.location.country
        session[:geoloc_by_ip_has_failed] = false
      end
    end

    def set_location
      if session[:user_ip_country].nil?
        get_location
        session[:user_ip_country] = @user_ip_country
      else
        @user_ip_country = session[:user_ip_country]
      end
    end

    def set_first_hit_tracker
      session[:first_hit].nil? ? session[:first_hit] = true : session[:first_hit] = false
    end

    def set_no_search_results_to_true_and_select_top10_by_country
      @no_search_results = true
      @firms = Firm.top10_by_country(@user_ip_country)
    end

    def set_no_search_results_to_false_and_select_top10_competitors_by_country
      @no_search_results = false
      @competitors = Firm.top10_by_industry_by_country(@firms.first.industry, @firms.first.country)
    end

    def define_search_results_variables_depending_on_search_results
      if @firms.empty?
        set_no_search_results_to_true_and_select_top10_by_country
      else
        set_no_search_results_to_false_and_select_top10_competitors_by_country
      end
    end

    def set_firms_list_on_search_results_or_country_index
      if params[:search]
        @firms = Firm.where("LOWER(name) LIKE ?", "%#{params[:search].downcase}%")
        define_search_results_variables_depending_on_search_results
      else
        @firms = Firm.top10_by_country(@user_ip_country)
      end
    end
    ################################
    # geosearch helpers methods
    def make_sure_there_is_a_firm_at_first_address_or_move_to_next_address_loop
      # while no firm are registered at the closest address and there are other addresses
      # pick the next addresss and set firms array to firms at this address
      i = 1
      while @firms.empty? && i < @addresses.length - 1
        @firms = @addresses[i].firms
        i += 1
      end
    end

    def set_closest_firm
      # collect the firms array at the closest address
      @firms = @addresses.first.firms
      make_sure_there_is_a_firm_at_first_address_or_move_to_next_address_loop
    end

    def look_up_closest_addresses_and_set_closest_firm
      # collect addresses of firms present in the database near the current latitude and longitude of the user
      @addresses = Address.near([params[:latitude].to_f, params[:longitude].to_f], 40, :order => "distance")
      set_closest_firm
    end
    ################################
    # Show helpers methods
    def set_user_and_select_latest_pending_review_for_this_firm
      set_user
      @user_pending_review_for_this_firm = @user.potentially_publishable_review_for_firm(@firm)
    end

    def select_latest_review_corresponding_to_review_token_stored_in_session
      @user_pending_review_for_this_firm = Review.find_by_token(session[:review_token])
    end

    def delete_review_token_in_session_and_in_db
      @user_pending_review_for_this_firm.update(token: "")
      @status = "disabled"
      session[:review_token] = ""
    end

    def select_pending_review_for_this_firm_if_any
      if user_signed_in?
        set_user_and_select_latest_pending_review_for_this_firm
      elsif session[:review_token] && session[:review_token].present?
        select_latest_review_corresponding_to_review_token_stored_in_session
        delete_review_token_in_session_and_in_db
      end
    end

    def set_main_review_variables_and_build_answers
      # variables for main review functionalities
      @tests = Test.all
      @review = Review.new
      @tests.each do |test|
        @review.answers.build(:test_id => test.id)
      end
    end

    def set_variables_for_ratings_and_trends
      # variables required by /app/views/firms/_community_ranking_details.html.erb
      # and /app/views/reviews/_review_form_answers.html.erb
      @avg_ratings_by_test = @firm.avg_ratings_by_test
      @current_period_averages = @firm.current_reporting_period_averages
      @previous_period_averages = @firm.previous_reporting_period_averages
    end

    def set_variables_for_js_immediate_display
      @total_by_test = @firm.total_by_test
      @answer_count_by_test = @firm.answers_count_by_test
    end

    def build_review_form
      set_main_review_variables_and_build_answers
      @current_stage = :first_time_vote
      set_variables_for_js_immediate_display
    end
    ################################
    # request firm addition helpers methods
    def flash_message_selector(flash_request)
      flash_messages = {
        firm_addition_request_success: {
          flash_message: t(
            'firm_addition_request_success',
            scope: [:controllers, :firms, :flash_message_selector],
            firm_name: params[:firm_name],
            default: "Your request to add \"#{params[:firm_name]}\" was received by our services. We are currently processing it."
            ),
          flash_type: "notice"
          },
        firm_addition_request_failure: {
          flash_message: t(
            'firm_addition_request_failure',
            scope: [:controllers, :firms, :flash_message_selector],
            firm_name: params[:firm_name],
            default: "Your request to add \"#{params[:firm_name]}\" could not be sent to our services. Please try again later."
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
