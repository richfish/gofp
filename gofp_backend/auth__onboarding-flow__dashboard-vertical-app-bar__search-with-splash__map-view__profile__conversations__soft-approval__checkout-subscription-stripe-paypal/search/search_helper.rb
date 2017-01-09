module SearchHelper

  def should_show_not_found_alert_subscription?
    true
  end

  def output_time_and_hour_selectors_for_days(form, times, hours, searchable_entity)
    ret = ""
    Program::DAYS_UTIL_HASH.each do |day, full_day|
      times_field = (day.to_s + '_start_time').to_sym
      hours_field = (day.to_s + '_mins').to_sym
      searchable_entity_time = searchable_entity.send("#{day.to_s}_start_time").presence
      searchable_entity_hours = searchable_entity.new_record? ? '3 Hours' : searchable_entity.decorate.min_to_hours_string_full(searchable_entity.send("#{day.to_s}_mins"))
      ret += <<-END
        <div id='#{day.to_s}_times_hours' style='display:none;'>
          <div class='form-group'>
            <h4 class='purple'>#{full_day.pluralize}</h4>
            <div class='form-inline'>
              <div class='form-group' style='min-width:110px'>
                Start Time
              </div>
              <div class='form-group'>
                #{form.select times_field, options_for_select(times, searchable_entity_time || '12:00 PM'), {}, {class: 'input-lg form-control selectpicker'}}
              </div>
            </div>
            <div class='form-inline'>
              <div class='form-group' style='min-width:110px'>
                Number Hours
              </div>
              <div class='form-group'>

                #{form.select hours_field, options_for_select(hours, searchable_entity_hours), {}, {class: 'input-lg form-control selectpicker'}}
              </div>
            </div>
          </div>
        </div>
      END
    end
    return ret.html_safe
  end

  def weekly_description_fields(form)
    ret = ""
    weeks = ["one", "two", "three", "four", "five", "six"]
    weeks.each do |week|
      field = 'week_' + week.to_s
      ret += <<-END
        <div class='form-group'>
          <h4> Week #{week.capitalize}</h4>
          #{form.text_area field, placeholder: 'E.g. Continuation of last week\'s prototyping, wrapping up front end whirlwind tour, refactoring exercise with image uploads, etc.', class: 'input-lg form-control', rows: 2 }
        </div>
      END
    end
    return ret.html_safe
  end

  # def allowable_format_for_level_text
  #   ret = case current_user.level
  #   when User::LEVEL_BEGINNER
  #     "As a Beginner Level, all searchable_entities follow a <b>6 week</b> format. This default format may change, but as you level up you will get able to tweak the format of your searchable_entity."
  #   when User::LEVEL_ADVANCED
  #     "As an Advanced Level, all searchable_entities follow a 6 week format. This default format may change, but as you level up you will get able to tweak the format of your searchable_entity."
  #   when User::LEVEL_TRUSTED
  #     "As a Trusted Level, all searchable_entities follow a 6 week format. This default format may change, but as you level up you will get able to tweak the format of your searchable_entity."
  #   when User::LEVEL_POWER
  #     "As a Power User Level, all searchable_entities follow a 6 week format. This default format may change, but as you level up you will get able to tweak the format of your searchable_entity."
  #   end
  #   ret.html_safe
  # end
  #
  # def allowable_num_participants_for_level_text
  #   ret = case current_user.level
  #   when User::LEVEL_BEGINNER
  #     "As a Beginner Level, all searchable_entities are with just <b>one participant</b>, but you can teach with other people. We value an extremely high teacher-student ratio. You can take on more participants per searchable_entity as you level up."
  #   when User::LEVEL_ADVANCED
  #     "You are an Advanced Level, all searchable_entities are with just one participant, but you can teach with other people. We value an extremely high teacher-student ratio. You can take on more participants per searchable_entity as you level up."
  #   when User::LEVEL_TRUSTED
  #     "You are a Trusted Level, all searchable_entities are with just one participant, but you can teach with other people. We value an extremely high teacher-student ratio. You can take on more participants per searchable_entity as you level up."
  #   when User::LEVEL_POWER
  #     "You are a Power User Level, all searchable_entities are with just one participant, but you can teach with other people. We value an extremely high teacher-student ratio. You can take on more participants per searchable_entity as you level up."
  #   end
  #   ret.html_safe
  # end
  #
  # def allowable_num_searchable_entities_for_level_text
  #   ret = case current_user.level
  #   when User::LEVEL_BEGINNER
  #     "As a Beginner Level, you can run up to <b>two simulatenous</b> searchable_entities. If you have less than two active searchable_entities (i.e. not completed or canceleld), than you can create another."
  #   when User::LEVEL_ADVANCED
  #     "You are an Advanced Level, you can run up to two simulatenous searchable_entities. If you have less than two active searchable_entities (i.e. not completed or canceleld), than you can create another."
  #   when User::LEVEL_TRUSTED
  #     "You are a Trusted Level, you can run up to two simulatenous searchable_entities. If you have less than two active searchable_entities (i.e. not completed or canceleld), than you can create another."
  #   when User::LEVEL_POWER
  #     "You are a Power User Level, you can run up to two simulatenous searchable_entities. If you have less than two active searchable_entities (i.e. not completed or canceleld), than you can create another."
  #   end
  #   ret.html_safe
  # end

  def num_hours_for_display(minutes)
    hours = (minutes/60).to_s
    if minutes % 60 == 30
      hours = hours + ".5"
    end
    hour_str = hours == "1" ? "Hour" : "Hours"
    return "#{hours} #{hour_str}"
  end

  def set_classes_for_searchable_entity_listing(searchable_entity)
    ret = ""
    if searchable_entity.unconfirmed?
      ret += 'unconfirmed-urgent'
    end
    return ret.html_safe
  end

  def searchable_entity_formatted_short_schedule(searchable_entity)
    ret = ""
    searchable_entity.days_of_week.each do |day|
      ret += "<div class='schedule_date_time no-wrap'> #{day}s: #{searchable_entity.meeting_time_range(day)} </div>"
    end
    return ret.html_safe
  end

  def rolling_or_start_date_display(searchable_entity)
    searchable_entity.rolling ? "Rolling Start" : "Start Date: #{searchable_entity.start_date}"
  end

  def display_number_participants(searchable_entity)
    "#{iconf('user')} <span style='font-size:13px;'>#{tooltip('One person - this searchable_entity is just for you.')}</span>".html_safe
  end

  def ps_schedule_formatted(searchable_entity)
    ret = "<div><b style='display:block;'>Available Days</b>"
    searchable_entity.days_of_week.each do |day|
      ret += "<p class='schedule_date_time no-wrap'> #{day}: #{searchable_entity.meeting_time_range(day)} </p>"
    end
    ret += "</div>"
    ret.html_safe
  end

  def schedule_formatted(searchable_entity)
    ret = ""
    ret += "<div><b style='display:block;'> 6 Weeks</b>"
    ret += searchable_entity_formatted_short_schedule(searchable_entity)
    ret += "</div>"
    ret += "<div style='marign-top:5px;'>"
    ret += "<i style='font-weight:300;'> #{rolling_or_start_date_display(searchable_entity)}</i>"
    if searchable_entity.rolling
      rolling_txt = current_user ? "The participant will suggest a start date, and you can accept or chat with him or her to decide." : "Rolling means you suggest the start date, and the provider either accepts or you can chat to decide."
      ret += "<span style='margin-left:5px'>#{tooltip("#{rolling_txt}")}</span>"
    end
    ret += "</div>"
    ret.html_safe
  end

  def schedule_formatted_search_results(searchable_entity)
    ret = ""
    ret += "<div><b style='display:block;color:#605A7F;font-size:14px;'>Rolling Start</b>"
    ret += searchable_entity_formatted_short_schedule(searchable_entity)
    ret += "</div>"
    ret.html_safe
  end

  def searchable_entity_status_text(searchable_entity)
    searchable_entity = searchable_entity.model rescue searchable_entity
    ret = if searchable_entity.unconfirmed? then "<b>Published</b> - new Applications!"
    elsif searchable_entity.pending_approval? then "<b>Pending Published</b> One-time Approval."
    elsif searchable_entity.unpublished? then "<b>New</b> - Not Published or Searchable"
    elsif searchable_entity.published? then "<b>Published</b> - Searchable - Bookable"
    elsif searchable_entity.confirmed? then "<b>Underway</b> - Have Fun!"
    elsif searchable_entity.complete? then "<b>Completed</b> - #{searchable_entity.decorate.start_date_end_date_range_with_day}"
    elsif searchable_entity.cancelled_or_stopped? then "<b>Cancelled</b> or Rejected"
    end
    ret.html_safe
  end

  def searchable_entity_status_text_long(searchable_entity)
    ret = if searchable_entity.unconfirmed?
      "<p>Your searchable_entity is published and at least one person has submitted an application! You have 48 hours to respond. Review the application on your dashboard, and confirm, reject, or, if the dates won't work, suggest rescheduling to another time.</p>"
    elsif searchable_entity.pending_approval?
        "<p>You're a first time user, and this means there is a one-time approval step. Mainly we're just looking to see that you are experienced, and that your profile and searchable_entity have sufficient information for users to make a choice.</p>"
    elsif searchable_entity.unpublished?
      "<p>Your searchable_entity is brand new, and you have not published it yet. No one can see it or book it. If you're ready, hit the 'Publish' button on your dashboard. Once someone books, you will have 48 hours to confirm or reject this booking.</p> <p> Note, if this is your very first searchable_entity with us, there will be a slight delay while we approve your profile and first searchable_entity. </p>"
    elsif searchable_entity.published?
      "<p>Your searchable_entity is searchable and bookable. If someone wants to book, you will receive a booking request and have 48 hours to confirm, reject, or, if the dates won't work, suggest rescheduling to another time. </p>"
    elsif searchable_entity.confirmed?
      "<p>Your searchable_entity is booked! Enjoy the experience as a teacher. If you only have one live searchable_entity, you will be able to create a second one from your dashboard page.</p>"
    elsif searchable_entity.complete?
      "<p>Your searchable_entity is complete. We trust it was a great experinece. If you do not have more than two live searchable_entities on your dashboard page, you can revive this searchable_entity directly by clicking the 'Revive' button on your dashboard. This will allow you to publish this exact searchable_entity once again (but you will need to edit it, if it is not rolling, i.e. it has a fixed start date which is now in the past).</p>"
    elsif searchable_entity.cancelled_or_stopped?
      "Your searchable_entity was cancelled or stopped."
    end
    ret.html_safe
  end

  #someting to show financial stuff (refunds amoung earned etc.)

  def searchable_entity_formatted_customer(searchable_entity)
    user_name = searchable_entity.user.full_name
    name_and_link = "<a href=#{user_path(id: searchable_entity.user.id)}>#{user_name}</a>"
    full_location = searchable_entity.location.location + ', ' + searchable_entity.user.city
    ret = <<-END
      <div class='searchable_entity_basic_info'>
        #{name_and_link} - #{searchable_entity.local_date} - #{searchable_entity.local_time} - #{searchable_entity.num_hours} hours
        <p><a href='#{regular_map_url(full_location)}' target='_blank'>#{iconf('map-marker')} #{full_location}</a></p>
      </div>
    END
    return ret.html_safe
  end

  def primary_tech_stack_formatted(technologies)
    ret = ""
    technologies.reverse.each do |tech|
      tech = "JS" if tech == "javascript"
      tech = "DESIGN" if tech == "css"
      ret += "<span class='searchable_entity_search_result__tech-tag'>#{tech}</span>"
    end
    return ret.html_safe
  end

  def what_gets_title
    current_user ? "What does the Participant get?" : "What You'll Get"
  end

  def participant_requirements_title
    current_user ? 'About the Participant, Requirements'  : 'About You, Requirements'
  end

  def cost_earnings_title
    current_user ? "Your Earnings (USD)" : "Cost (USD)"
  end

  def set_program_generic_icon(program)
    img = program.is_a?(searchable_entity) ? "lightningbolt.png" : "lightningbolt.png"
    image_tag img, class: 'bc-other-offerings__type-icon'
  end

  def set_program_path(program)
    if program.is_a? searchable_entity
      user_searchable_entity_path(program.user, program)
    elsif program.is_a? PowerSession
      user_power_session_path(program.user, program)
    end
  end

  def should_show_other_offerings?
    Program.for_provider(@searchable_entity.user).count > 1
  end

  def other_open_programs(searchable_entity)
    Program.for_provider(searchable_entity.user) - Array.wrap(searchable_entity.model)
  end

  def should_allow_booking_prompt?
    !params[:checkout].present? && !params[:confirmation_page].present? && !params[:review].present? && !current_user
  end

  def should_show_instructor_profile?
    !current_user || params[:invitation].present?
  end

  def should_show_instructor_reviews?
    should_show_instructor_profile?
  end

  def should_show_special_actions?
    false
    #params[:checkout].present? || params[:confirmation_page].present? || params[:reivew].present?
  end

  def should_show_searchable_entity_actions?
    current_user && params[:invitation].blank?
  end

  def should_disable_buttons_for_instructor?
    current_user && params[:invitation].blank?
  end

end
