class PoliciesController < ApplicationController
  layout 'policies'

  def general
    render "policies/articles/general/general"
  end

  def sleeping
    render "policies/articles/general/sleeping"
  end

  def alerts
    render "policies/articles/general/alerts"
  end

  def monitoring
    render "policies/articles/general/monitoring"
  end

  def grandfathering
    render "policies/articles/general/grandfathering"
  end

  def payments
    render "policies/articles/general/payments"
  end

  def geography
    render "policies/articles/general/geography"
  end

  def cancellation
    render "policies/articles/general/cancellations"
  end

  def failure
    render "policies/articles/general/failure"
  end

  def the_texts
    render "policies/articles/general/the_texts"
  end

end
