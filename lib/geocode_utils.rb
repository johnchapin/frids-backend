class GeocodeUtils

  STATUS_MESSAGES = { 200 => "GEO_SUCCESS",
              601 => "GEO_MISSING_ADDRESS",
              602 => "GEO_UNKNOWN_ADDRESS",
              603 => "GEO_UNAVAILABLE_ADDRESS",
              610 => "GEO_BAD_KEY",
              620 => "GEO_TOO_MANY_QUERIES",
              500 => "GEO_SERVER_ERROR" }

  def self.ping
    results = Geocoding::get("1600 Pennsylvania Ave, Washington D.C., USA")
    return results.status
  end


end
