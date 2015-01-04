class TodaysDeadAppointment < Appointment
  default_scope { today.where(status: ["Cancelled by Student", "Cancelled by Instructor", "Rescheduled by Student", "Rescheduled by Instructor"]) }

  rails_admin do

    parent ""
    navigation_label "Today's Schedule"
    weight 0

    label_plural do
      "Cancelled/Rescheduled Appointments"
    end

    label do
      "Today's Cancelled/Rescheduled"
    end

    list do
      field :id
      field :instructor
      field :student
      field :start_time do
        strftime_format "%l:%M %p"
      end

      field :appointment_category
      field :status
    end

    show do
      field :id
      field :instructor
      field :student
      field :appointment_category

      field :start_time do
        strftime_format "%A, %B %e, %Y - %l:%M %p"
      end

      field :end_time do
        strftime_format "%A, %B %e, %Y - %l:%M %p"
      end

      field :status

      field :created_at do
        strftime_format "%A, %B %e, %Y - %l:%M %p"
        visible do
          bindings[:view].current_user.admin?
        end
      end

      field :updated_at do
        strftime_format "%A, %B %e, %Y - %l:%M %p"
        visible do
          bindings[:view].current_user.admin?
        end
      end
    end

    edit do
      field :instructor do
        inline_add false
        inline_edit false
        visible do
          bindings[:view].current_user.admin?
        end
        associated_collection_scope do
          Proc.new { |scope| scope = scope.active }
        end
      end

      field :student do
        inline_add false
        inline_edit false
        read_only do
          !(bindings[:view].current_user.admin?)
        end
        help do
          !(bindings[:view].current_user.admin?) ? "" : "#{help}"
        end
        associated_collection_scope do
          Proc.new { |scope| scope = scope.active }
        end
      end

      field :appointment_category do
        inline_add false
        inline_edit false
        read_only do
          !(bindings[:view].current_user.admin?)
        end
        help do
          !(bindings[:view].current_user.admin?) ? "" : "#{help}"
        end
      end

      field :start_time do
        read_only do
          !(bindings[:view].current_user.admin?)
        end
        help do
          !(bindings[:view].current_user.admin?) ? "" : "#{help}"
        end
      end
      
      field :status, :enum do
        read_only do
          !(bindings[:view].current_user.admin?) && !(bindings[:object].editable_status_by_instructor?)
        end
        enum do
          bindings[:object].status_options
        end
        help do
          "Required. An Appoinment marked 'Unavailable' will not be available to any Students, as long as it is not marked as 'Re-bookable' (see next field)."
        end
      end

      field :re_bookable do
        read_only do
          !(bindings[:view].current_user.admin?) && bindings[:object].dead?
        end
        label do
          "Re-bookable?"
        end
        help do
          "IMPORTANT: Marking an Appointment 'Re-bookable' will open it up to be booked by other Students. An Appointment is usually 'Re-bookable' when a previous Student cancelled his/her appointment, with enough time to allow another Student to take the slot."
        end
      end
    end
  end
end