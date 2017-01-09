class PoliciesController < ApplicationController
  layout 'policies'

  def policies_provider
    render :provider_general
  end

  def policies_general
    render "policies/articles/general/general"
  end

  def general_acceptance
     render "policies/articles/general/acceptance"
  end

  def general_bootcamp_logistics
    render "policies/articles/general/bootcamp_logistics"
  end

  def general_cancellations_refunds
    render "policies/articles/general/cancellations_refunds"
  end

  def general_disputes_resolutions
    render "policies/articles/general/disputes_resolutions"
  end

  def general_payments
   render "policies/articles/general/payments"
  end

  def general_reviews
    render "policies/articles/general/reviews"
  end



  def provider_general
    render "policies/articles/provider/general"
  end

  def provider_auto_cancellations
    render "policies/articles/provider/auto_cancellations"
  end

  def provider_levels
    render "policies/articles/provider/levels"
  end

  def provider_obligations
    render "policies/articles/provider/obligations"
  end

  def provider_payouts
    render "policies/articles/provider/payouts"
  end

  def provider_profile_guidelines
    render "policies/articles/provider/profile_guidelines"
  end

  def provider_reviews_ratings
    render "policies/articles/provider/reviews_ratings"
  end

  def provider_bootcamp_logistics
    render "policies/articles/provider/bootcamp_logistics"
  end

  def provider_search_visibility
    render "policies/articles/provider/search_visibility"
  end

  def provider_invite_participants
    render "policies/articles/provider/invite_participants"
  end

end