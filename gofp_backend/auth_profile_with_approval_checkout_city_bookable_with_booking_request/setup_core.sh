###PASS IN THE NAME OF THE 'BOOKABLE ASSET' AT THE VERY TOP, PASS IT IN SNAKE CASE

APP_NAME=$1
if [ "$1" = "" ]; then
  echo "you need to give an app name"
  exit 1
fi

if [ "$2" = "" ]; then
  echo "for the second argument, provide the name for the bookable asset with underscores (snake case) if multi words"
  exit 1
fi
BOOKABLE_ASSET_NAME=$2

if [ "$3" = "" ]; then
  echo "for the third argument, provide the name for the 'booking request' (e.g. 'rental', 'application') with underscores (snake case) if multi words"
  exit 1
fi
BOOKING_REQUEST_NAME=$3


echo "Well hello"
echo "WARNING"
echo "*****************************************************************"
echo "*****************************************************************"
echo "Stop this script now if:"
echo "your app name isn't a lowercase single word."
echo "you don't have Postgres.app and have it set in your PATH (http://postgresapp.com/documentation/cli-tools.html)"
echo "you don't have image magick"
echo "you don't have Redis"
echo "you don't have Ruby 2.1.3"
echo "you don't have Git"
echo "*****************************************************************"
echo "*****************************************************************"
echo "STARTING THEN..."
echo "*****************************************************************"
echo "Script for Common Files & Theme, Devise, User Account, Paypal/ Stripe/ Orders/ Refunds/ Checkout, Profiles + Avatatrs, City-Specific"
echo "*****************************************************************"

sh common_files.sh $APP_NAME
sh devise_setup.sh $APP_NAME
sh paypal_and_stripe_setup.sh $APP_NAME $BOOKABLE_ASSET_NAME
sh profile_setup.sh $APP_NAME
sh city_selection.sh $APP_NAME
sh profile_approval_and_issue_flow.sh $APP_NAME
sh static_pages_setup.sh $APP_NAME
sh bookable_asset_setup.sh $APP_NAME $BOOKABLE_ASSET_NAME
sh booking_request_setup.sh $APP_NAME $BOOKABLE_ASSET_NAME $BOOKING_REQUEST_NAME
sh all_mailers.sh $APP_NAME $BOOKABLE_ASSET_NAME $BOOKING_REQUEST_NAME

echo "DONE"
echo "*****************************************************************"
echo "*****************************************************************"
echo "Now..."
echo "mv your app out of this directory"
echo "In separate tabs fire up the server, fire up Sidekiq, fire up Redis:"
echo "redis-server"
echo "Sidekiq: bundle exec sidekiq -C config/sidekiq.yml"
echo "rails s"
echo "Also run guard in another tab by typing 'guard' if you want."
echo "FIN"