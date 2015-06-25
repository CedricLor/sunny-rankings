class FirmsController < ApplicationController
  before_action :set_firm, only: [:show]

  def index
    if params[:search]
      @firms = Firm.where("name LIKE ?", "%#{params[:search]}%")
      if @firms.empty?
        @no_search_results = true
        @firms = Firm.all
      end
    else
      @firms = Firm.all
    end
  end

  def show
    @firms = Firm.all
    @tests = Test.all
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
