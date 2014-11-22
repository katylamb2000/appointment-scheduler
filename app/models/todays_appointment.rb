class TodaysAppointment < Appointment
  default_scope { where('start_time > ?', Date.today.beginning_of_day).where('end_time < ?', Date.today.end_of_day) }

  rails_admin do
    label do
      "Today's Appointment"
    end

    list do
      field :id
      field :instructor
      field :user do
        label do
          "Student"
        end
      end
      field :start_time
      field :appointment_category
      field :status
    end

    show do
      field :id
      field :instructor
      field :user do
        label do
          "Student"
        end
      end
      field :appointment_category
      field :start_time
      field :end_time
      field :status
      field :created_at do
        visible do
          bindings[:view].current_user.admin?
        end
      end
      field :updated_at do
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
          Proc.new { |scope| scope = scope.where(instructor: true) }
        end
      end

      field :user do
        inline_add false
        inline_edit false

        label do
          "Student"
        end

        read_only do
          !(bindings[:view].current_user.admin?)
        end

        help do
          !(bindings[:view].current_user.admin?) ? "" : "#{help}"
        end

        associated_collection_scope do
          Proc.new { |scope| scope = scope.where(instructor: false).where(admin: false) }
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
          ["Open", "Future", "Past - Occurred", "Cancelled by Student", "Cancelled by Instructor", "Rescheduled by Student", "Rescheduled by Instructor", "No Show"]
        end
      end
    end
  end
end