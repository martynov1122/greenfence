class GeolocationServices < Services
  attr_reader :geocoder

  def initialize(geocoder=Geokit::Geocoders::MultiGeocoder)
    @geocoder = geocoder
  end

  def geocode(address)
    geocoder.geocode(address)
  end
end
