class AvailabilitiesController < ApplicationController # TODO remove? currently implemented via rails_admin

  def index
    if current_user.admin?
      @availabilities = Availability.all
    else
      @availabilities = current_user.availabilities
    end
  end

  def new
    @availability = Availability.new
  end

  def create
  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
  end
end
