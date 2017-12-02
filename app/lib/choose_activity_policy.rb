# Given a speed and a location type, determine which activity applies
class ChooseActivityPolicy

  LOCATION_TYPES = %i[field road other]

  attr_reader :speed, :location_type

  def initialize(speed, location_type)
    unless LOCATION_TYPES.include? location_type
      raise "Invalid location_type: #{location_type}. Must be one of #{LOCATION_TYPES.join(',')}"
    end
    @speed = speed
    @location_type = location_type
  end

  def activity
    send(location_type)
  end

  def field
    if speed > 1.0
      :cultivating
    else
      :repairing
    end
  end

  def road
    if speed > 5.0
      :driving
    else
      :slacking_off
    end
  end

  def other
    :awol
  end

end
