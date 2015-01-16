class Api::V1::AvailabilitiesController < Api::V1::ApiController
  def index
    @user = User.find(params[:user_id])
    return user_is_not_instructor! unless @user.instructor?

    start_date = params[:start]
    end_date = params[:end]
    @events = @user.full_calendar_availabilities_between(start_date, end_date)
    render json: @events, status: :ok and return
  end

  private

    def default_serializer_options
      { root: false }
    end

    def user_is_not_instructor!
      render json: { errors: [ "User is not an instructor" ] }, status: :unprocessable_entity and return
    end
end