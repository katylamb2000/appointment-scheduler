class AvailabilitySerializer < ActiveModel::Serializer
  attributes :id, :title, :start, :end

  def title # TODO is this sloppy?
    "to #{object.end_time.strftime('%l:%M %p')}"
  end

  def start
    object.start_time
  end

  def end
    object.end_time
  end
end
