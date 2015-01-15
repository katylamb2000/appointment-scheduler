class Api::V1::AvailabilitiesController < Api::V1::ApiController
  def index
    @user = User.find(params[:user_id])
    return user_is_not_instructor! unless @user.instructor?

    @availabilities = @user.availabilities
    render json: @availabilities, status: :ok and return
  end

  private

    def default_serializer_options
      { root: false }
    end

    def user_is_not_instructor!
      render json: { errors: [ "User is not an instructor" ] }, status: :unprocessable_entity and return
    end
end