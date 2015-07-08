class FirmsController < ApplicationController
  # before_action :set_firm, only: [:show, :add_review]
  before_action :set_firm, only: [:show ]

  def index
    if params[:search]
      @firms = Firm.where("LOWER(name) LIKE ?", "%#{params[:search].downcase}%")
      if @firms.empty?
        @no_search_results = true
        @firms = Firm.top10_by_country("Belgium")
      else
        @no_search_results = false
        @competitors = Firm.top10_by_industry_by_country(@firms.first.industry, @firms.first.country)
      end
    else
      @firms = Firm.top10_by_country("Belgium")
    end
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

end
