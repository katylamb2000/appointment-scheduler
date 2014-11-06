class AvailabilitiesController < ApplicationController

  def index
    @availabilities = current_user.availabilities
  end
end
