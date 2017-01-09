class BookableAssetActionsController < ApplicationController
  def confirm
    bookable_asset = current_user.bookable_assets.find(params[:bookable_asset_id])
    booking_request = bookable_asset.booking_requests.find(params[:booking_request_id])
    booking_request.accept!
    flash[:notice] = "BookableAsset confirmed!"
    redirect_to user_path(current_user)
  end

  def reject
    #make sure this doesn't update bookable_asset status, just booking_request status.
    bookable_asset = current_user.bookable_assets.find(params[:bookable_asset_id])
    booking_request = bookable_asset.booking_requests.find(params[:booking_request_id])
    booking_request.provider_reject!
    flash[:notice] = "You rejected this bookable_asset booking_request."
    redirect_to user_path(current_user)
  end

  # def reschedule
  #   bookable_asset = current_user.bookable_assets.find(params[:id])
  #   booking_request = bookable_asset.booking_requests.find(params[:booking_request])
  #   booking_request.reschedule_note = params[:reschedule_note]
  #   booking_request.reschedule_date = params[:reschedule_date]
  #   booking_request.save
  #   bookable_asset.reschedule!(booking_request)
  #   flash[:notice] = "Successfuly sent request to reschedule dates."
  #   redirect_to user_path(current_user)
  # end

  def confirm_from_email
    bookable_asset = BookableAsset.find_by_euid(params[:euid])
    booking_request = bookable_asset.booking_requests.find(params[:booking_request_id])
    redirect_path = current_user ? user_path(current_user) : login_path

    if bookable_asset.confirmed?
      flash[:warn] = "You've already accepted this booking_request"
      return redirect_to redirect_path
    end
    booking_request.accept!

    flash[:notice] = "You've accepted this booking_request."
    redirect_to redirect_path
  end

  def revive
    bookable_asset = current_user.bookable_assets.past.find(params[:bookable_asset_id])
    if current_user.can_create_another_bookable_asset?
      bookable_asset.revive!
      flash[:notice] = "BookableAsset is revived (duplicated). You can now edit or publish it."
      redirect_to user_path(current_user)
    else
      flash[:warn] = "You have too many current BookableAssets, cannot revive a past one."
      redirect_to user_path(current_user)
    end
  end

  # def accepts_rescheduling
  #   #can be from the client (accepting provider's request) or can be from provider (accepign client's re-request); don't depend on current user
  #   #expects the new date coming in params
  #   booking_request = BookingRequest.find_by_app_key(params[:euid])
  #   booking_request.update_attributes({rolling_start_date: params[:reschedule_date]})
  #   #may want extra validation for date format
  #   bookable_asset = booking_request.bookable_asset
  #   bookable_asset.confirm!(booking_request)
  #   flash[:notice] = "Successfuly confirmed bookable_asset!."
  #   if current_user
  #     redirect_to user_path(current_user)
  #   else
  #     #generic static page for guests...
  #     redirect_to root_path
  #   end
  # end
  #
  # def request_new_rescheduling
  #   #please don't use this, for the love of god (overengineering)
  #   booking_request = BookingRequest.find_by_app_key(params[:euid])
  #   booking_request.reschedule_note = params[:reschedule_note]
  #   booking_request.reschedule_date = params[:reschedule_date]
  #   booking_request.save
  #
  #   bookable_asset = booking_request.bookable_asset
  #   bookable_asset.reschedule!(booking_request)
  #   flash[:notice] = "Successfuly sent request to reschedule dates."
  #   if current_user
  #     redirect_to user_path(current_user)
  #   else
  #     #generic static page for guests
  #     redirect_to root_path
  #   end
  # end

  def publish
    bookable_asset = current_user.bookable_assets.unpublished.find(params[:bookable_asset_id])
    profile_status = bookable_asset.user.profile.status
    ProfileAndBookableAssetPublishManager.new(bookable_asset).publish
    flash[:notice] = if profile_status == Profile::STATUS_PUBLISHED
      "Your BookableAsset is published - it is searchable and bookable."
    else
      "You're Pending Published. Check back soon, and we'll email you when you're live."
    end
    redirect_to user_path(current_user)
  end

  def unpublish
    bookable_asset = current_user.bookable_assets.published.find(params[:bookable_asset_id])
    ProfileAndBookableAssetPublishManager.new(bookable_asset).unpublish
    flash[:notice] = "Unpublished bookable_asset"
    redirect_to user_path(current_user)
  end

end