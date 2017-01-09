#3 TYPES OF EXPIRATION COUNTDOWNS

class AutoCancellationPolicy
  IMMINENT_BOOKING_EXPIRATION = 12 + 1
  IMMINENT_BOOKING_EXPIRATION_BOUNDARY = 48
  LESS_IMMINENT_BOOKING_EXPIRATION = 24 + 1
  LESS_IMMINENT_BOOKING_EXPIRATION_BOUNDARY = 72
  FAR_AWAY_BOOKING_EXPIRATION = 48 + 1

  def self.hours_left(booking, booking_time_manager)
    # created_at = booking.created_at
    # hours_passed_since_creation = (Time.now - created_at).to_i/3600
    # time_between_creating_and_outing = booking_time_manager.time_between_creating_and_outing
    # hours_left = if time_between_creating_and_outing < LESS_IMMINENT_BOOKING_EXPIRATION_BOUNDARY
    #   if time_between_creating_and_outing < IMMINENT_BOOKING_EXPIRATION_BOUNDARY
    #     IMMINENT_BOOKING_EXPIRATION - hours_passed_since_creation
    #   else
    #     LESS_IMMINENT_BOOKING_EXPIRATION - hours_passed_since_creation
    #   end
    # else
    #   FAR_AWAY_BOOKING_EXPIRATION - hours_passed_since_creation
    # end
    # return hours_left
    30
  end
end