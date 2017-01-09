#ASSUMES USER TABLE EXISTS
#order stuff (orders_controller, views; migrations; model)
#add account/ refund objects/ migrations; logic for callback on accounts; AccountManager


APP_NAME=$1
if [ "$1" = "" ]; then
  echo "you need to give an app name"
  exit 1
fi

CAPITALIZED_APP_NAME=`ruby -e "puts '$APP_NAME'.capitalize"`

echo "setting up paypal and stripe for $APP_NAME"

echo "javascripts"
cp stripe_and_paypal/stripe_custom.js.coffee $APP_NAME/app/assets/javascripts/view_js
cp stripe_and_paypal/checkout.js.coffee $APP_NAME/app/assets/javascripts/view_js

echo "paypal.yml & paypal.rb"
cp stripe_and_paypal/paypal.yml $APP_NAME/config
cp stripe_and_paypal/paypal.rb $APP_NAME/config/initializers

echo "application.rb with weird paypal logic fix for now"
cp stripe_and_paypal/application.rb $APP_NAME/config/application.rb
echo "replacing name in module"
echo > tmpfile_for_sed
sed "s/Boilerplate/$CAPITALIZED_APP_NAME/g" $APP_NAME/config/application.rb > tmpfile_for_sed
mv tmpfile_for_sed $APP_NAME/config/application.rb

echo "stripe.rb initializer"
cp stripe_and_paypal/stripe.rb $APP_NAME/config/initializers

echo "lib classes paypal"
cp stripe_and_paypal/paypal_manager.rb $APP_NAME/lib
cp stripe_and_paypal/paypal_ipn.rb $APP_NAME/lib

echo "copy payment icons"
cp stripe_and_paypal/btc_logo.jpeg $APP_NAME/app/assets/images
cp stripe_and_paypal/paypal_logo.jpg $APP_NAME/app/assets/images
cp stripe_and_paypal/stripe_transparent.png $APP_NAME/app/assets/images

echo "paypal ipn migration"
cd $APP_NAME
rails g model IpnNotification payment_status payment_date payer_email payer_id receiver_email txn_id first_name last_name mc_gross mc_fee mc_currency custom payment_gross user:references
rake db:migrate
cd ..

echo "orders migration"
cd $APP_NAME
rails g model Order name email stripe_token amount_cents:integer stripe_customer_hash paypal_identifier paypal_payer_id paypal:boolean stripe:boolean euid order_key first_name last_name fee_cents:integer unsubscribed:boolean
rake db:migrate
cd ..

echo "money helper file"
cp stripe_and_paypal/money_helper.rb $APP_NAME/app/helpers/money_helper.rb

echo "orders model"
cp stripe_and_paypal/order.rb $APP_NAME/app/models/order.rb

echo "orders controller"
cp stripe_and_paypal/orders_controller.rb $APP_NAME/app/controllers/orders_controller.rb

echo "order related views/ cc form"
echo "this is way more crap than you need, but is nice template for checkout and confirm pages"
mkdir $APP_NAME/app/views/orders
cp -r stripe_and_paypal/order_views/ $APP_NAME/app/views/orders

echo "add order_helper"
cp stripe_and_paypal/order_helper.rb $APP_NAME/app/helpers/order_helper.rb

echo "update css manifest"
cp stripe_and_paypal/css_manifest.css.sass $APP_NAME/app/assets/stylesheets/application.css.sass

echo "add administration.yml/rb for fee"
cp stripe_and_paypal/administration.yml $APP_NAME/config/$APP_NAME'_administration.yml'
cp stripe_and_paypal/administration.rb $APP_NAME/config/initializers/$APP_NAME'_administration.rb'
echo > tmpfile_for_sed
sed "s/boilerplate/$APP_NAME/g" $APP_NAME/config/initializers/$APP_NAME'_administration.rb' > tmpfile_for_sed
mv tmpfile_for_sed $APP_NAME/config/initializers/$APP_NAME'_administration.rb'

#User AA's Order default
# echo "generate active admin"
# cd $APP_NAME
# rails g active_admin:resource Order
# cd ..
# cp stripe_and_paypal/admin_order.rb $APP_NAME/app/admin/order.rb

echo "updating and cancelling CC logic"
#update routes
cp stripe_and_paypal/users_controller.rb $APP_NAME/app/controllers/users_controller.rb
cp stripe_and_paypal/stripe_cc_manager.rb $APP_NAME/lib/
cp stripe_and_paypal/service_canceller.rb $APP_NAME/lib/
cp stripe_and_paypal/user_edit.haml $APP_NAME/app/views/users/edit.haml


echo "updating emails"
mkdir $APP_NAME/app/views/user_mailer
cp stripe_and_paypal/notify_cancelled_subscription.haml $APP_NAME/app/views/user_mailer/
cp stripe_and_paypal/subscription_confirmation.haml $APP_NAME/app/views/user_mailer/
mkdir $APP_NAME/app/views/admin_mailer
cp stripe_and_paypal/alert_of_sale.haml $APP_NAME/app/views/admin_mailer/alert_of_sale.haml

echo "add lightweight payments modal"
cp stripe_and_paypal/payment_modal.haml $APP_NAME/app/views/orders/_payment_modal.haml
cp stripe_and_paypal/purchase_item.css.sass $APP_NAME/app/assets/stylesheets

echo "update user model"
cp stripe_and_paypal/user.rb $APP_NAME/app/models/user.rb


echo "Done Stripe"
