# Given a lat/lon coordinate, determine if that spot represents a field or a road
class LocationLookup

  attr_reader :lat, :lon

  def initialize(lat, lon)
    @lat = lat
    @lon = lon
  end

  def location_type
    # TODO For now, as a simple hack:
    # Any positive lat or 0: field
    # Any negative lat: road
    if lat >= 0
      :field
    else
      :road
    end
  end

end
