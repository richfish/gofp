#ASSUMES USER TABLE EXISTS
#order stuff (orders_controller, views; migrations; model)
#add account/ refund objects/ migrations; logic for callback on accounts; AccountManager


APP_NAME=$1
if [ "$1" = "" ]; then
  echo "you need to give an app name"
  exit 1
fi
if [ "$2" = "" ]; then
  echo "for the second argument, provide the name for the bookable asset with underscores (snake case) if multi words"
  exit 1
fi

CAPITALIZED_APP_NAME=`ruby -e "puts '$APP_NAME'.capitalize"`

BOOKABLE_ASSET_NAME=$2
BOOKABLE_ASSET_NAME_CAMEL=`ruby -e "puts '$BOOKABLE_ASSET_NAME'.split(\"_\").map(&:capitalize).join()"`
BOOKABLE_ASSET_NAME_SNAKE_PLURAL=`ruby -e "puts '$BOOKABLE_ASSET_NAME' + 's'"`
BOOKABLE_ASSET_NAME_CAMEL_PLURAL=`ruby -e "puts '$BOOKABLE_ASSET_NAME'.split(\"_\").map(&:capitalize).join() + 's'"`

function replace_bookable_asset_strings {
  #$1 is the write destination in the app
  echo > tmpfile_for_sed
  sed "s/bookable_asset/$BOOKABLE_ASSET_NAME/g" $1 > tmpfile_for_sed
  mv tmpfile_for_sed $1

  echo > tmpfile_for_sed
  sed "s/BookableAsset/$BOOKABLE_ASSET_NAME_CAMEL/g" $1 > tmpfile_for_sed
  mv tmpfile_for_sed $1

  echo > tmpfile_for_sed
  sed "s/BookableAssets/$BOOKABLE_ASSET_NAME_CAMEL_PLURAL/g" $1 > tmpfile_for_sed
  mv tmpfile_for_sed $1

  echo > tmpfile_for_sed
  sed "s/bookable_assets/$BOOKABLE_ASSET_NAME_SNAKE_PLURAL/g" $1 > tmpfile_for_sed
  mv tmpfile_for_sed $1
}


echo "setting up paypal and stripe for $APP_NAME"

echo "javascripts"
cp paypal_and_stripe/stripe_custom.js.coffee $APP_NAME/app/assets/javascripts/view_js
cp paypal_and_stripe/checkout.js.coffee $APP_NAME/app/assets/javascripts/view_js

echo "paypal.yml & paypal.rb"
cp paypal_and_stripe/paypal.yml $APP_NAME/config
cp paypal_and_stripe/paypal.rb $APP_NAME/config/initializers

echo "application.rb with weird paypal logic fix for now"
cp paypal_and_stripe/application.rb $APP_NAME/config/application.rb
echo "replacing name in module"
echo > tmpfile_for_sed
sed "s/Boilerplate/$CAPITALIZED_APP_NAME/g" $APP_NAME/config/application.rb > tmpfile_for_sed
mv tmpfile_for_sed $APP_NAME/config/application.rb

echo "stripe.rb initializer"
cp paypal_and_stripe/stripe.rb $APP_NAME/config/initializers

echo "lib classes paypal"
cp paypal_and_stripe/paypal_manager.rb $APP_NAME/lib
cp paypal_and_stripe/paypal_ipn.rb $APP_NAME/lib

echo "copy payment icons"
cp paypal_and_stripe/btc_logo.jpeg $APP_NAME/app/assets/images
cp paypal_and_stripe/paypal_logo.jpg $APP_NAME/app/assets/images
cp paypal_and_stripe/stripe_transparent.png $APP_NAME/app/assets/images

echo "paypal ipn migration"
cd $APP_NAME
rails g model IpnNotification payment_status payment_date payer_email payer_id receiver_email txn_id first_name last_name mc_gross mc_fee mc_currency custom payment_gross
rake db:migrate
cd ..

echo "account migration"
cd $APP_NAME
rails g model Account user:references balance:integer total_refunds:integer total_earnings:integer
rake db:migrate
rails g migration AddDefaultsToAccountFields
cd ..
find $APP_NAME/db/migrate -name '*add_defaults_to_account*' | xargs -I '{}' cp paypal_and_stripe/add_defaults_to_account_fields.rb '{}'
cd $APP_NAME
echo "migrating again adding defaults"
rake db:migrate
cd ..

echo "refund migration"
cd $APP_NAME
rails g model Refund issue_description:text amount_cents:integer account:references
rake db:migrate
rails g migration AddDefaultsToRefundFields
cd ..
find $APP_NAME/db/migrate -name '*add_defaults_to_refund*' | xargs -I '{}' cp paypal_and_stripe/add_defaults_to_refund_fields.rb '{}'
cd $APP_NAME
echo "migrating again adding defaults"
rake db:migrate
cd ..

echo "orders migration"
cd $APP_NAME
rails g model Order name email stripe_token amount_cents:integer stripe_customer_hash paypal_identifier paypal_payer_id paypal:boolean stripe:boolean euid order_key first_name last_name fee_cents:integer participant_amount_cents:integer account:references captured:boolean capture_rejected:boolean admin_auth_voided:boolean
rake db:migrate
cd ..

echo "account model"
cp paypal_and_stripe/account.rb $APP_NAME/app/models/account.rb

echo "account views"
cp paypal_and_stripe/account_display.haml $APP_NAME/app/views/users/_account_display.haml
cp paypal_and_stripe/account_display_first_time.haml $APP_NAME/app/views/users/_account_display_first_time.haml
replace_bookable_asset_strings $APP_NAME/app/views/users/_account_display_first_time.haml
replace_bookable_asset_strings $APP_NAME/app/views/users/_account_display.haml

echo "money helper file"
cp paypal_and_stripe/money_helper.rb $APP_NAME/app/helpers/money_helper.rb

echo "orders model"
cp paypal_and_stripe/order.rb $APP_NAME/app/models/order.rb

echo "refunds model"
cp paypal_and_stripe/refund.rb $APP_NAME/app/models/refund.rb

echo "refunds active admin view"
mkdir $APP_NAME/app/admin/views
cp paypal_and_stripe/create_refund_admin.haml $APP_NAME/app/admin/views/create_refund.haml

echo "orders controller"
cp paypal_and_stripe/orders_controller.rb $APP_NAME/app/controllers/orders_controller.rb

echo "order related views/ cc form"
echo "this is way more crap than you need, but is nice template for checkout and confirm pages"
mkdir $APP_NAME/app/views/orders
cp -r paypal_and_stripe/order_views/ $APP_NAME/app/views/orders

echo "lib account_manager"
cp paypal_and_stripe/account_manager.rb $APP_NAME/lib

echo "updating routes file"
cp paypal_and_stripe/complete_routes.rb $APP_NAME/config/routes.rb

echo "update user model"
cp paypal_and_stripe/user.rb $APP_NAME/app/models/user.rb

echo "add order_helper"
cp paypal_and_stripe/order_helper.rb $APP_NAME/app/helpers/order_helper.rb

echo "update css manifest"
cp paypal_and_stripe/css_manifest.css.sass $APP_NAME/app/assets/stylesheets/application.css.sass

echo "add paypal_email field to user"
cd $APP_NAME
rails g migration AddPaypalEmailToUser paypal_email
rake db:migrate
cd ..

echo "add administration.yml/rb for fee"
cp paypal_and_stripe/administration.yml $APP_NAME/config/$APP_NAME'_administration.yml'
cp paypal_and_stripe/administration.rb $APP_NAME/config/initializers/$APP_NAME'_administration.rb'
echo > tmpfile_for_sed
sed "s/boilerplate/$APP_NAME/g" $APP_NAME/config/initializers/$APP_NAME'_administration.rb' > tmpfile_for_sed
mv tmpfile_for_sed $APP_NAME/config/initializers/$APP_NAME'_administration.rb'

echo "update _alerts page to take paypal email"
cp paypal_and_stripe/alerts_partial.haml $APP_NAME/app/views/layouts/_alerts.haml

echo "generate active admin"
cd $APP_NAME
rails g active_admin:resource Order
cd ..
cp paypal_and_stripe/admin_order.rb $APP_NAME/app/admin/order.rb

cd $APP_NAME
git add .
git commit -m "adding paypal, stripe, and related models & classes"
cd ..

echo "All done then!"

