class ReviewsController < ApplicationController
  before_filter :verify_reviewer, except: :index

  def new
  end

  def create
    @review = @bookable_asset.build_review(set_params)
    @review.user_id = @bookable_asset.user.id
    if @review.save
      flash[:notice] = "Review created."
      return redirect_to review_success_path
    else
      render :new
    end
  end

  def index
  end

  private

  def verify_reviewer
    @bookable_asset = BookableAsset.find_by_review_key(params[:euid])

    if @bookable_asset.review.present?
      flash[:warn] = "You've Already Reviewed this Outing"
      return redirect_to root_path
    end
  end

  def set_params
    params.require(:review).permit(:teaching_ability, :value_of_experience, :satisfaction, :overall, :synopsis, :private_message)
  end

end
