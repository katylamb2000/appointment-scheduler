class AppointmentCategory < ActiveRecord::Base
  validates_presence_of :lesson_minutes, :buffer_minutes, :price
  validates_uniqueness_of :lesson_minutes
  validates :lesson_minutes, :buffer_minutes, :price, numericality: { greater_than: 0 }

  has_many :appointments

  def total_duration
    lesson_minutes + buffer_minutes
  end

  def price_in_cents
    price * 100
  end

  def display_price
    sprintf "$%.2f", price
  end

  def name # for rails admin
    "#{lesson_minutes} Minute Appt"
  end

  rails_admin do
    label do
      "Appointment Category"
    end
    list do
      field :id
      field :lesson_minutes
      field :buffer_minutes
      field :price do
        pretty_value do
          sprintf "$%.2f", value
        end
      end
    end

    show do
      field :id
      field :price do
        pretty_value do
          sprintf "$%.2f", value
        end
      end
      field :lesson_minutes
      field :buffer_minutes
      field :total_duration
      field :created_at
      field :updated_at
    end

    edit do
      field :lesson_minutes
      field :buffer_minutes
      field :price do
        help do
          "Required. Price in USD."
        end
      end
    end
  end
end