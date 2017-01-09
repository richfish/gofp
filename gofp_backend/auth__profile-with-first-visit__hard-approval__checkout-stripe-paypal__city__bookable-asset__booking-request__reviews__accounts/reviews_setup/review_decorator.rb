class ReviewDecorator < Draper::Decorator
  delegate_all

  def display_name
    app = self.bookable_asset.booking_requests.accepted.first
    [app.first_name, app.last_name].join(" ")
  end

  def display_bookable_asset_name
    self.bookable_asset.name
  end

  def display_bookable_asset_dates
    self.bookable_asset.decorate.start_date_end_date_range
  end
end