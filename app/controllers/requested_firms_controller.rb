class RequestedFirmsController < ApplicationController
  def create
  end

  def update
  end

  private
    def requested_firm_params
      params.require(:requested_firm).permit(:name)
    end
end