# #ALL TIMES ARE SAVED IN UTC - BUT MUST GO THROUGH STEP TO CONVERT TO LOCAL TIMEZONE BEFORE SAVING (IN UTC)
#
# class BookableAssetTimeManager
#
#   attr_accessor :bookable_asset
#
#   def initialize(bookable_asset)
#     @bookable_asset = bookable_asset
#   end
#
#   def hours_until_cancellation
#     AutoCancellationPolicy.hours_left(bookable_asset, self)
#   end
#
#   def excluded_timeslots_due_to_bookable_asset
#     ExcludedTimeslotPolicy.get_excluded_timeslots(bookable_asset)
#   end
#
#   def get_start_time
#     local_start_time
#   end
#
#   def get_end_time
#     hours = bookable_asset.num_hours
#     get_start_time + hours.hours
#   end
#
#   def time_between_creating_and_outing
#     created_at = bookable_asset.created_at + 1.hour
#     (get_start_time - created_at).to_i/3600
#   end
#
#   def hours_since_bookable_asset_ended
#     (Time.now - get_end_time).to_i/3600
#   end
#
#   def time_until_start_in_hours
#     (get_start_time - Time.now).to_i/3600
#   end
#
#   def bookable_asset_within_24_hours?
#     return false if start_time_is_in_past?
#     (get_start_time - Time.now) < 24.hours
#   end
#
#   def end_time_is_in_past?
#     get_end_time < Time.now
#   end
#
#   def start_time_is_in_past?
#     get_start_time < Time.now
#   end
#
#   def local_start_time(time=nil)
#     time_raw = time || bookable_asset.date_and_time
#     city = bookable_asset.artist.city
#     tz = CITY_TIMEZONE_HASH[city]
#     ActiveSupport::TimeZone[tz].parse(time_raw.to_s)
#   end
#
#   def local_date_and_day
#     [local_start_time.strftime(Schedule::DATEFORMAT), local_start_time.strftime("%a").downcase.to_sym]
#   end
#
#   def start_slot_end_slot
#     [bookable_asset.timeslot, end_timeslot]
#   end
#
#   def local_start_time_end_time
#     [local_start_time.strftime(BookableAsset::INTERNAL_TIMEFORMAT).squish, local_end_time.strftime(BookableAsset::INTERNAL_TIMEFORMAT).squish]
#   end
#
#   def local_end_time
#     get_end_time
#   end
#
#   def all_timeslots_booked_for_day?
#     excluded_timeslots_due_to_bookable_asset.map(&:to_i) == [1,2,3,4]
#   end
#
#   def bookable_asset_on_same_date_as?(date)
#     get_start_time.strftime(Schedule::DATEFORMAT) == date
#   end
#
#   def end_timeslot
#     end_time_str = get_end_time.strftime(Schedule::TIMEFORMAT_MILITARY)
#     hours = end_time_str[Schedule::HOUR_REGEXP, 1].to_i
#     minutes = end_time_str[Schedule::MINUTE_REGEXP, 1].to_i
#     time = if hours < 12
#       "11:45" #default to 4th timeslot if early am
#     elsif hours == 12
#       minutes = minutes.to_s.size == 1 ? "0#{minutes}" : minutes
#       "#{hours}:#{minutes}"
#     else
#       minutes = minutes.to_s.size == 1 ? "0#{minutes}" : minutes
#       "#{hours - 12}:#{minutes}"
#     end
#     BookableAsset::TIMESELECTOPTIONS.find{|slot,times| time.in?(times)}[0]
#   end
# end