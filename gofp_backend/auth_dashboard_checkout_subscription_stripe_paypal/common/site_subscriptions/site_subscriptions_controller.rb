class SiteSubscriptionsController < ApplicationController

  def create
    subscription = SiteSubscription.new(params.require(:site_subscription).permit(:email))
    if subscription.save
      respond_to{ |format| format.json {head :ok} }
    else
      redirect_to root_path
    end
  end

end
