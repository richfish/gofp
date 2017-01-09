class BookableAssetsController < ApplicationController
  #YOU SHOULD PROBABLY OVERWRITE THIS WITH THE GOFP GENERIC FORM/VIEW/CONTROLLER GENERATOR RAKE TASK

  #CUSTOMIZE
  #before_filter ->{ @bookable_asset(s) = current_user.bookable_asset(s) }

  def new
  end

  def index
  end

  def show
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def set_params
    params.require(:bookable_asset).permit!
  end

end