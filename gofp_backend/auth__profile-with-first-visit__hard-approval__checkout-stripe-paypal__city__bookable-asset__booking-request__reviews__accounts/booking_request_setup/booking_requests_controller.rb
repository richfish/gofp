class BookingRequestsController < ApplicationController
  #obviously will need to change a lot of this

  def new
  end

  def create
    #the incoming fom embedded in the customer view page for the bookable_asset.
    @bookable_asset = BookableAsset.bookable.find(params[:bookable_asset_id]).decorate
    @booking_request = @bookable_asset.booking_requests.build(set_params) #may want to use custom error solution instead
    return unless set_email_attributes(params[:booking_request])
    if @booking_request.save
      redirect_to new_order_path(euid: @booking_request.euid)
    else
      render :new
    end
  end

  def show
    @booking_request = BookingRequest.find_by_euid(params[:euid])
    @bookable_asset = @booking_request.bookable_asset.decorate
  end

  def edit
    @booking_request = BookingRequest.find_by_euid(params[:euid])
    @bookable_asset = @booking_request.bookable_asset.decorate
  end

  def update
    @booking_request = BookingRequest.find_by_euid(params[:euid])
    if @booking_request.update_attributes(set_params)
      flash[:notice] = "Changes saved."
      redirect_to new_order_path(euid: @booking_request.euid)
    else
      render :edit
    end
  end


  private

  def set_params
    params.require(:booking_request).permit(:first_name, :last_name, :linkedin_profile, :rolling_start_date, :background, :hopeful_gains, :reschedule_note, :misc_notes, :email, :email_confirm, :bookable_asset_id, :flexible)
  end
end
