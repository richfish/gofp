#ALL TIMES ARE SAVED IN UTC - BUT MUST GO THROUGH STEP TO CONVER TO LOCAL TIMEZONE BEFORE SAVING (IN UTC)
#THIS ASSUMES BOOTCAMP HAS BEEN BOOKED, THAT IT HAS OFFICIAL START TIME

class BookableAssetTimeManager

  attr_accessor :bookable_asset

  def initialize(bookable_asset)
    @bookable_asset = bookable_asset
  end

  def hours_since_booking_ended
    (Time.now - get_end_time).to_i/3600
  end

  def local_start_date_and_time
     date_time = "#{bookable_asset.start_date} #{start_time_first_meetup_of_week}"
     tz = CITY_TIMEZONE_HASH[bookable_asset.user.city]
     ActiveSupport::TimeZone[tz].parse(date_time)
   end

   def local_end_date_and_time
     date_time = "#{end_date_of_bookable_asset} #{end_time_last_meetup}"
     tz = CITY_TIMEZONE_HASH[bookable_asset.user.city]
     ActiveSupport::TimeZone[tz].parse(date_time)
   end

   def end_day_of_bookable_asset_sym
     dow = bookable_asset.days_of_week
     if dow.size >1
       if dow.include? "Sunday" then :sun
       elsif dow.include? "Saturday" then :sat
       elsif dow.include? "Friday" then :fri
       elsif dow.include? "Thursday" then :thu
       elsif dow.include? "Wednesday" then :wed
       elsif dow.include? "Tuesday" then :tue
       elsif dow.include? "Monday" then :mon
       end
     else
       BookableAsset::DAYS_UTIL_HASH.invert[dow.first]
     end
   end

   def end_time_last_meetup
     end_day = end_day_of_bookable_asset_sym
     start_time = bookable_asset.send("#{end_day.to_s}_start_time")
     mins = bookable_asset.send("#{end_day.to_s}_mins")
     time_raw = Time.parse(start_time.to_s) + mins.minutes
     time_raw.strftime(BookableAsset::TIMEFORMAT_NON_MILITARY)
   end

   def end_date_of_bookable_asset
     end_day = end_day_of_bookable_asset_sym
     end_date = if bookable_asset.days_of_week.size > 1
       if end_day == (local_start_date_and_time + 1.days).strftime("%a").downcase.to_sym
         local_start_date_and_time + 1.days
       elsif end_day == (local_start_date_and_time + 2.days).strftime("%a").downcase.to_sym
         local_start_date_and_time + 2.days
       elsif end_day == (local_start_date_and_time + 3.days).strftime("%a").downcase.to_sym
         local_start_date_and_time + 3.days
       elsif end_day == (local_start_date_and_time + 4.days).strftime("%a").downcase.to_sym
         local_start_date_and_time + 4.days
       elsif end_day == (local_start_date_and_time + 5.days).strftime("%a").downcase.to_sym
         local_start_date_and_time + 5.days
       elsif end_day == (local_start_date_and_time + 6.days).strftime("%a").downcase.to_sym
         local_start_date_and_time + 6.days
       end
     else
       DateTime.parse(bookable_asset.start_date)
     end
     (end_date + 5.weeks).strftime(BookableAsset::DATEFORMAT)
   end

   def start_time_first_meetup_of_week
     dow = bookable_asset.days_of_week
     if dow.size > 1
       if dow.include? "Monday"
         bookable_asset.mon_start_time
       elsif dow.include? "Tuesday"
         bookable_asset.tue_start_time
       elsif dow.include? "Wednesday"
         bookable_asset.wed_start_time
       elsif dow.include? "Thursday"
         bookable_asset.thu_start_time
       elsif dow.include? "Friday"
         bookable_asset.fri_start_time
       elsif dow.include? "Saturday"
         bookable_asset.sat_start_time
       elsif dow.include? "Sunday"
         bookable_asset.sun_start_time
       end
     else
       day_sym = BookableAsset::DAYS_UTIL_HASH.invert[dow.first]
       bookable_asset.send("#{day_sym.to_s}_start_time")
     end
   end

  def hours_until_cancellation(booking_request)
    AutoCancellationPolicy.hours_left(booking_request)
  end

  def get_start_time
    bookable_asset.local_start_date_and_time
  end

  def get_end_time
    local_end_date_and_time
  end

  def start_date_and_time
    local_start_date_and_time
  end

  def time_between_creating_and_outing
    created_at = bookable_asset.created_at + 1.hour
    (get_start_time - created_at).to_i/3600
  end

  def hours_since_bookable_asset_ended
    (Time.now - get_end_time).to_i/3600
  end

  def time_until_start_in_hours
    (get_start_time - Time.now).to_i/3600
  end

  def bookable_asset_within_24_hours?
    return false if start_time_is_in_past?
    (get_start_time - Time.now) < 24.hours
  end

  def end_time_is_in_past?
    get_end_time < Time.now
  end

  def start_time_is_in_past?
    get_start_time < Time.now
  end

  def local_date_and_day
    [local_start_time.strftime(BookableAsset::DATEFORMAT), local_start_time.strftime("%a").downcase.to_sym]
  end

  def local_start_time_end_time
    [local_start_time.strftime(BookableAsset::INTERNAL_TIMEFORMAT).squish, local_end_time.strftime(BookableAsset::INTERNAL_TIMEFORMAT).squish]
  end

  def local_end_time
    get_end_time
  end

  def local_start_time
    get_start_time
  end

  def bookable_asset_on_same_date_as?(date)
    get_start_time.strftime(BookableAsset::DATEFORMAT) == date
  end

end