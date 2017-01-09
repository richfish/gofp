cities = HashWithIndifferentAccess.new(YAML.load_file("config/cities.yml"))
CITIES = cities[:cities_with_tz].keys
CITY_TIMEZONE_HASH = cities[:cities_with_tz]
CITY_RULES = cities[:rules]

rails_timezones = ActiveSupport::TimeZone.all.map(&:name)
unless CITY_TIMEZONE_HASH.values.all?{ |tz| tz.in? rails_timezones }
  errant = CITY_TIMEZONE_HASH.find{|k,v| !v.in? rails_timezones }
  puts errant
  raise "timezone issue"
end

#TODO move healthcheck