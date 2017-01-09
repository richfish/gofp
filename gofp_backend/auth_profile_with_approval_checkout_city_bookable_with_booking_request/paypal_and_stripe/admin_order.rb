ActiveAdmin.register Order do

  show do |order|
    attributes_table do
      row :name
      row :email
      row :stripe_token
      row :amount_cents do
        "raw cents #{order.amount_cents} - formatted #{number_to_currency(order.amount_cents)}"
      end
      row :stripe_customer_hash
      row :paypal_identifiier
      row :paypal_payer_id
      row :paypal
      row :stripe
      row :euid
      row :first_name
      row :last_name
      row :fee_cents do
        "raw cents #{order.fee_cents} OR formatted - #{number_to_currency order.fee_cents}"
      end
      row :account_id do
        link_to "account_id - #{order.account_id}", tibetan_sherpa_access_account_path(order.account)
      end
      row :bootcamp_application_id do
        link_to "bootcamp_application_id - #{order.bootcamp_application_id}", tibetan_sherpa_access_bootcamp_application_path(order.bootcamp_application)
      end
      row :captured
      row "IMPORTANT INTERNAL STUFF BELOW" do
        "Capture_rejected is set directly after a provider cancels an application or it auto expires. admin_auth_voided needs to be done manually by admin whenever a charge gets voided."
      end
      row :capture_rejected
      row :admin_auth_voided
      row "IMPORTANT ACTION BELOW" do
      end
      row "Admin Auth Voided Action" do
        button_to "ADMIN VOID AUTHORIZATION - BE CAREFUL", void_auth_tibetan_sherpa_access_order_path(order), method: :get
      end
      row :created_at
      row :updated_at
    end
  end

  member_action :void_auth, method: :get do
    order = Order.find(params[:id])
    order.admin_void_auth!
    flash[:notice] = "Authorization successfully voided"
    redirect_to tibetan_sherpa_access_order_path
  end

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end
