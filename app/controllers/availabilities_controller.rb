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
    @availability = Availability.new(availability_params)
    set_schedule!

    if @availability.save
      redirect_to availability_path(@availability)
    else
      flash[:errors] = @availability.errors.full_messages
      clear_schedule!
      render :edit
    end
  end

  def edit
    @availability = Availability.find(params[:id])
  end

  def show
    @availability = Availability.find(params[:id])
  end

  def update
  end

  def destroy
  end

  private

    def availability_params
      params.require(:availability).permit(:instructor_id, :start_time, :end_time, :schedule, :number_of_occurrences, :schedule_end_date)
    end

    def set_schedule!
      @availability.schedule = IceCube::Schedule.new(@availability.start_time, end_time: @availability.end_time)
      if setting_reccurring_schedule?
        return invalid_rule! if invalid_rule?
        rule = set_rule!
        @availability.schedule.add_recurrence_rule(rule)
      else
        ensure_schedule_limits_are_not_set!
      end
    end

    def setting_reccurring_schedule?
      !(availability_params[:schedule] == "null")
    end

    def invalid_rule!
      flash[:errors] = ["We're sorry, but something went wrong - Please try again."]
      @availability = Availability.new
      render :edit and return
    end

    def invalid_rule?
      !(RecurringSelect.is_valid_rule?(availability_params[:schedule]))
    end

    def set_rule!
      rule = RecurringSelect.dirty_hash_to_rule(availability_params[:schedule]).count(occurrence_number) if setting_occurrence_number?
      rule = RecurringSelect.dirty_hash_to_rule(availability_params[:schedule]).until(chosen_end_date) if setting_end_date?
      rule ||= RecurringSelect.dirty_hash_to_rule(availability_params[:schedule])
      return rule
    end

    def setting_occurrence_number?
      !(availability_params[:number_of_occurrences].blank?)
    end

    def occurrence_number
      availability_params[:number_of_occurrences].to_i
    end

    def setting_end_date?
      !(availability_params[:schedule_end_date].blank?)
    end

    def chosen_end_date
      availability_params[:schedule_end_date].to_datetime
    end

    def clear_schedule!
      @availability.schedule = {}
    end

    def ensure_schedule_limits_are_not_set! # TODO should this be a model validation? if you are not setting a recurrence rule, we don't want bad data in the schedule_end_date or number_of_occurrences fields. or remove these fields all together and set as virtual.
      @availability.number_of_occurrences = nil
      @availability.schedule_end_date = nil
    end
end
