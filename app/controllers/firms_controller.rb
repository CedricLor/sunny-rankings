class FirmsController < ApplicationController
  before_action :set_firm, only: [:show, :add_review]

  def index
    if params[:search]
      @firms = Firm.where("LOWER(name) LIKE ?", "%#{params[:search].downcase}%")
      if @firms.empty?
        @no_search_results = true
        @firms = Firm.top10_by_country("Belgium")
      else
        @no_search_results = false
      end
    else
      @firms = Firm.top10_by_country("Belgium")
    end
  end

  def show
    @firms = Firm.all
    @tests = Test.all
  end

  def add_review
    @review = Review.new
    @tests = Test.all
    @answer = @review.answers.build
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
