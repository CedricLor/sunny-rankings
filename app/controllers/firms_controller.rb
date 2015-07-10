class FirmsController < ApplicationController
  # before_action :set_firm, only: [:show, :add_review]
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
    redirect_to firm_path(@firms.last)
  end

  def show
    @competitors = Firm.top10_by_industry_by_country(@firm.industry, @firm.country)
    @tests = Test.all
    @review = Review.new
    @tests.each do |test|
      @review.answers.build(:test_id => test.id)
    end
    @current_averages = @firm.current_reporting_period_averages
    @previous_averages = @firm.previous_reporting_period_averages
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
        @user_ip_country = request.location.country_name
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
