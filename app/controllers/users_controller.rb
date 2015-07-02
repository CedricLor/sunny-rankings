class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def update
  end

  def edit
  end

  private

  def users_params
  end
end
