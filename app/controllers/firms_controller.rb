class FirmsController < ApplicationController
  before_action :set_firm, only: [:show ]

  def index
    set_location
    set_first_hit_tracker
    if params[:search]
      @firms = Firm.where("LOWER(name) LIKE ?", "%#{params[:search].downcase}%")
      if @firms.empty?
        @no_search_results = true
        @firms = Firm.top10_by_country(@user_ip_country)
      else
        @no_search_results = false
        @competitors = Firm.top10_by_industry_by_country(@firms.first.industry, @firms.first.country)
      end
    else
      @firms = Firm.top10_by_country(@user_ip_country)
    end
  end

  def geosearch
    addresses = Address.near([params[:latitude].to_f, params[:longitude].to_f], 40, :order => "distance")
    @firms = addresses.first.firms
    i = 1
    while @firms.empty? && i < addresses.length - 1
      @firms = addresses[i].firms
      i += 1
    end
    if @firms.empty?
      redirect_to firms_path
    else
      redirect_to firm_path(@firms.first)
    end
  end

  def show
    if user_signed_in?
      @potentially_publishable_by_user_review_for_firm = current_user.potentially_publishable_review_for_firm(@firm)
    elsif session[:review_token] && session[:review_token].present?
      @potentially_publishable_by_user_review_for_firm = Review.find_by_token(session[:review_token])
      @potentially_publishable_by_user_review_for_firm.update(token: "")
      @status = "disabled"
      session[:review_token] = ""
    end
    @competitors = Firm.top10_by_industry_by_country(@firm.industry, @firm.country)
    @tests = Test.all
    @review = Review.new
    @tests.each do |test|
      @review.answers.build(:test_id => test.id)
    end
    # providing variable to build ratings and trends
    @current_stage = :first_time_vote
    @avg_ratings_by_test = @firm.avg_ratings_by_test
    @current_period_averages = @firm.current_reporting_period_averages
    @previous_period_averages = @firm.previous_reporting_period_averages
    # providing variable for javascript immediate display
    @total_by_test = @firm.total_by_test
    @answer_count_by_test = @firm.answers_count_by_test
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

  private

  def firms_params
    params.require(:firm).permit(:name, :address, :country, :headcount, :business_description, :business_sector, :icon_name)
  end

  def set_firm
    @firm = Firm.find(params[:id])
  end

  def set_location
    if session[:user_ip_country].nil?
      if request.location.country == "Reserved"
        @user_ip_country = "France"
        session[:geoloc_by_ip_has_failed] = true
      else
        @user_ip_country = request.location.country
        session[:geoloc_by_ip_has_failed] = false
      end
      session[:user_ip_country] = @user_ip_country
    else
      @user_ip_country = session[:user_ip_country]
    end
  end

  def set_first_hit_tracker
    if session[:first_hit].nil?
      session[:first_hit] = true
    else
      session[:first_hit] = false
    end
  end
end
