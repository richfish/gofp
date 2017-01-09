#ASSUMES USER TABLE EXISTS
#order stuff (orders_controller, views; migrations; model)
#add account/ refund objects/ migrations; logic for callback on accounts; AccountManager


APP_NAME=$1
if [ "$1" = "" ]; then
  echo "you need to give an app name"
  exit 1
fi

CAPITALIZED_APP_NAME=`ruby -e "puts '$APP_NAME'.capitalize"`

echo "setting stripe for $APP_NAME"

echo "javascripts"
cp stripe/stripe_custom.js.coffee $APP_NAME/app/assets/javascripts/view_js
cp stripe/checkout.js.coffee $APP_NAME/app/assets/javascripts/view_js

echo "stripe.rb initializer"
cp stripe/stripe.rb $APP_NAME/config/initializers

echo "copy payment icons"
cp stripe/btc_logo.jpeg $APP_NAME/app/assets/images
cp stripe/stripe_transparent.png $APP_NAME/app/assets/images

echo "orders migration"
cd $APP_NAME
rails g model Order name email stripe_token amount_cents:integer stripe_customer_hash euid order_key first_name last_name
rake db:migrate
cd ..

echo "money helper file"
cp stripe/money_helper.rb $APP_NAME/app/helpers/money_helper.rb

echo "orders model"
cp stripe/order.rb $APP_NAME/app/models/order.rb

echo "orders controller"
cp stripe/orders_controller.rb $APP_NAME/app/controllers/orders_controller.rb

echo "order related views/ cc form"
echo "this is way more crap than you need, but is nice template for checkout and confirm pages"
mkdir $APP_NAME/app/views/orders
cp -r stripe/order_views/ $APP_NAME/app/views/orders

echo "add order_helper"
cp stripe/order_helper.rb $APP_NAME/app/helpers/order_helper.rb

echo "update css manifest"
cp stripe/css_manifest.css.sass $APP_NAME/app/assets/stylesheets/application.css.sass

echo "add administration.yml/rb for fee"
cp stripe/administration.yml $APP_NAME/config/$APP_NAME'_administration.yml'
cp stripe/administration.rb $APP_NAME/config/initializers/$APP_NAME'_administration.rb'
echo > tmpfile_for_sed
sed "s/boilerplate/$APP_NAME/g" $APP_NAME/config/initializers/$APP_NAME'_administration.rb' > tmpfile_for_sed
mv tmpfile_for_sed $APP_NAME/config/initializers/$APP_NAME'_administration.rb'

# echo "generate active admin"
# cd $APP_NAME
# rails g active_admin:resource Order
# cd ..
# cp stripe/admin_order.rb $APP_NAME/app/admin/order.rb

echo "Done Stripe"
