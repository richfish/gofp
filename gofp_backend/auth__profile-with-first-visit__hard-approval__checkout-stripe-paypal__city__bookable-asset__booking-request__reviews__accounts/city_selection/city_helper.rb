module CityHelper
  def city_validation_markup
    ret = <<-END
      <div class='form-group'>
        <div id='rule_match_notice' style='display:none'>
          We detected a different area you may want to use. See our suggestion below, and try resubmitting.
        </div>
        <div id='no_support_notice' style='display:none'>
          Hmm we don't seem to support this city. Check your spelling, try a nearby city, or write to us [give me a link].
        </div>
      </div>
    END
    return ret.html_safe
  end
end