class TodaysAvailability < Availability
  default_scope { where('start_time > ?', Date.today.beginning_of_day).where('end_time < ?', Date.today.end_of_day) }

  rails_admin do
    label do
      "Today's Availability"
    end

    list do
      field :id
      field :instructor
      field :start_time do
        formatted_value do
          value.strftime("%l:%M %p")
        end
      end
      field :end_time do
        formatted_value do
          value.strftime("%l:%M %p")
        end
      end
    end

    show do
      field :id
      field :instructor
      field :start_time
      field :end_time
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
      field :start_time
      field :end_time
    end
  end
end