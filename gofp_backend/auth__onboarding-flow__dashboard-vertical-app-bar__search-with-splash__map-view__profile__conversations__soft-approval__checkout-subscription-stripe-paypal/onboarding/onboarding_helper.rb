module OnboardingHelper
  def step_1_complete?
    get_session_val("test_field_1").present?
  end

  def step_2_complete?
    get_session_val("test_field_2").present?
  end

  def step_3_complete?
    get_session_val("test_field_3").present?
  end

  def step_4_complete?
    get_session_val("test_field_4").present?
  end

  def get_session_val(key)
    session[:onboarding].try(:[], key)
  end
end
