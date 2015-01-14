class AvailabilitySerializer < ActiveModel::Serializer
  attributes :id, :start, :end

  def start
    object.start_time
  end

  def end
    object.end_time
  end
end
