class OnboardingsController < ApplicationController

  layout "onboarding"

  def index
    @step_id = conform_step_id(params[:step_id])
    if @step_id <= num_onboarding_steps
      render "onboardings/step#{@step_id}"
    else
      complete_onboarding()
    end
  end

  def create
    #should add validations & rendering back before incrementing step or adding to session data
    session[:onboarding] ||= {}
    session[:onboarding].merge!(params[:onboarding] || {})
    next_step_num = conform_step_id(params[:step_id]) + 1
    redirect_to onboardings_path(step_id: next_step_num)
  end

  private

  def complete_onboarding
    session[:onboarding]
    # create, validate user
    # sign in user
    # delete session data
    # redirect_to root_path
  end

  def conform_step_id(raw_step)
    return 1 unless raw_step
    raw_step.to_i <= (num_onboarding_steps + 1) ? raw_step.to_i : 1
  end

  def num_onboarding_steps
    ADMINISTRATIVE_SETTINGS[:onboarding_steps].to_i
  end

end
