class TodaysAvailability < Availability
  default_scope { where('start_time > ?', Date.today.beginning_of_day).where('end_time < ?', Date.today.end_of_day) }

  rails_admin do
    parent ""
    navigation_label "Today"
    weight 1
    label do
      "Availability"
    end

    list do
      field :id
      field :instructor
      field :start_time do
        strftime_format "%l:%M %p"
      end
      field :end_time do
        strftime_format "%l:%M %p"
      end
    end

    show do
      field :id
      field :instructor
      field :start_time do
        strftime_format "%A, %B %e, %Y - %l:%M %p"
      end
      field :end_time do
        strftime_format "%A, %B %e, %Y - %l:%M %p"
      end
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
          Proc.new { |scope| scope = scope.where(instructor: true) }
        end
      end
      field :start_time
      field :end_time
    end
  end
end