ActiveAdmin.register Review do

  show do |review|
    attributes_table do
      row :teaching_ability
      row :value_of_experience
      row :satisfaction
      row :overall
      row :private_message
      row :synopsis
      row :flagged
      row :acknowledged
      row :created_at
      row :updated_at

      row "BELOW IS IMPORTANT" do
      end

      row "ACKNOWLEDGE REVIEW" do
        unless review.acknowledged
          link_to "Acknowledge it!", acknowledge_review_tibetan_sherpa_access_review_path(review), method: :get
        end
      end

      row "BELOW IS IMPORTANT" do
      end

      row "FLAG THIS REVIEW" do
        link_to "flag it!", flag_review_tibetan_sherpa_access_review_path(review), method: :get
      end
    end
  end

  member_action :acknowledge_review, method: :get do
    review = Review.find(params[:id])
    review.update_attribute(:acknowledged, true)
    flash[:notice] = "Review acknowledged!"
    redirect_to tibetan_sherpa_access_review_path(review)
  end

  member_action :flag_review, method: :get do
    review = Review.find(params[:id])
    review.update_attribute(:flagged, true)
    flash[:notice] = "Review flagged!"
    redirect_to tibetan_sherpa_access_review_path(review)
  end


end
