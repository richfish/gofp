class BookableAssetActionsController < ApplicationController
  def confirm
    bookable_asset = current_user.bookable_assets.find(params[:id])
    bookable_asset.confirm!
    flash[:notice] = "Successfuly confirmed bookable_asset!."
    redirect_to user_path(current_user)
  end

  def reject
    #make sure this doesn't update bookable_asset status, just application status.
    bookable_asset = current_user.bookable_assets.find(params[:id])
    bookable_asset.provider_cancel!
    flash[:notice] = "Successfuly rejected bookable_asset application."
    redirect_to user_path(current_user)
  end

  def reschedule
    bookable_asset = current_user.bookable_assets.find(params[:id])
    bookable_asset.reschedule!(params[:reschedule_note])
    flash[:notice] = "Successfuly sent request to reschedule dates."
    redirect_to user_path(current_user)
  end

  def confirm_from_email
    bookable_asset = Booking.find(params[:bookable_asset_id])
    return unless verify_secuirty_key(bookable_asset.bookable_asset_confirmation_key)

    bookable_asset.confirm!
    flash[:notice] = "Success, you've confirmed this bookable_asset."
    redirect_to confirm_email_successs_path
  end

  def revive
  end

  def publish
    bookable_asset = current_user.bookable_assets.unpublished.find(params[:id])
    ProfileAndBookableAssetPublishManager.new(bookable_asset).publish
    flash[:notice] = "Success - You're Pending Published. Check back soon, and we'll email you when you're live."
    redirect_to user_path(current_user)
  end

end