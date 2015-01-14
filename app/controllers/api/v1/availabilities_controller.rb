class Api::V1::AvailabilitiesController < Api::V1::ApiController
  def index
    user = User.find(params[:user_id])
    @availabilities = user.availabilities
    render json: @availabilities, status: :ok and return
  end
end