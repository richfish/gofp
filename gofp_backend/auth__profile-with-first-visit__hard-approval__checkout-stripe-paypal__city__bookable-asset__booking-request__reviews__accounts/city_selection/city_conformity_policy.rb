class CityConformityPolicy

  def self.get_allowable_city(city_raw)
    retreive_city(city_raw)
  end

  def self.illegal_city?(city_raw)
    city_raw != retreive_city(city_raw)
  end

  private

  def self.retreive_city(city)
    CITY_RULES[city] || FuzzyMatch.new(CITIES).find(city)
  end
end