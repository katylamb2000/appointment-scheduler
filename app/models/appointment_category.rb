class AppointmentCategory < ActiveRecord::Base
  validates_presence_of :lesson_minutes, :buffer_minutes, :price_in_cents
  validates_uniqueness_of :lesson_minutes
  validates :lesson_minutes, :buffer_minutes, :price_in_cents, numericality: { greater_than: 0 }

  def total_duration
    lesson_minutes + buffer_minutes
  end

  def price_in_dollars
    price_in_cents / 100
  end

  rails_admin do
    list do
      field :id
      field :lesson_minutes
      field :buffer_minutes
      field :price_in_dollars do
        label do
          "Price"
        end
        pretty_value do
          "$#{value}0" # TODO fix this hack
        end
      end
    end

    show do
      field :id
      field :price_in_dollars do
        label do
          "Price"
        end
        pretty_value do
          "$#{value}0" # TODO fix this hack
        end
      end
      field :lesson_minutes
      field :buffer_minutes
      field :total_duration
    end

    edit do
      field :lesson_minutes
      field :buffer_minutes
      field :price_in_cents do
        label do
          "Price"
        end
        help do
          "Required. MUST BE IN CENTS"
        end
      end
    end
  end
end