class ProfileDecorator < Draper::Decorator
  include MixinDummyDataDecorator
  
  delegate_all

  def steps_left
    # if complete? then 0
    # elsif !profile_info_complete? then 3
    # elsif schedule.present? && !has_required_timeslot_locations? then 1
    # elsif profile_info_complete? then 2
    # else 3 end
    3
  end

  def complete?
    #profile_info_complete? && schedule.present? && has_required_timeslot_locations?
  end

  def profile_info_complete?
    # main_fields = [first_name, datingbio, service_description, customer_gender, target_gender].all?(&:present?)
    # rate = rate_cents.present? || beers
    # main_fields && rate
    false
  end

  def has_image?
    self.user.avatar.try(:image).try(:present?)
  end

end
