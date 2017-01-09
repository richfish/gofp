class SearchEntitySubscriptionsController < ApplicationController

  #add custom fields
  def create
    search_entity_subscription = SearchEntitySubscription.new(params.require(:search_entity_subscription).permit(:email))
    if search_entity_subscription.save
      respond_to{ |format| format.json {head :ok} }
    else
      redirect_to root_path
    end
  end
end
