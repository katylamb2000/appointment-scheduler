class AvailabilitiesController < ApplicationController # TODO remove? currently implemented via rails_admin

  def index
    @availabilities = current_user.availabilities
  end
end
