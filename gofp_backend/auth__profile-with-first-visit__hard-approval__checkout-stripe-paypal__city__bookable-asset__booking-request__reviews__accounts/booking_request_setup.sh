APP_NAME=$1
if [ "$1" = "" ]; then
  echo "you need to give an app name"
  exit 1
fi
if [ "$2" = "" ]; then
  echo "for the second argument, provide the name for the bookable asset with underscores (snake case) if multi words"
  exit 1
fi
if [ "$3" = "" ]; then
  echo "for the third argument, provide the name for the 'booking request' (e.g. 'rental', 'application') with underscores (snake case) if multi words"
  exit 1
fi
BOOKABLE_ASSET_NAME=$2
BOOKABLE_ASSET_NAME_CAMEL=`ruby -e "puts '$BOOKABLE_ASSET_NAME'.split(\"_\").map(&:capitalize).join()"`
BOOKABLE_ASSET_NAME_SNAKE_PLURAL=`ruby -e "puts '$BOOKABLE_ASSET_NAME' + 's'"`
BOOKABLE_ASSET_NAME_CAMEL_PLURAL=`ruby -e "puts '$BOOKABLE_ASSET_NAME'.split(\"_\").map(&:capitalize).join() + 's'"`

BOOKING_REQUEST_NAME=$3
BOOKING_REQUEST_NAME_CAMEL=`ruby -e "puts '$BOOKING_REQUEST_NAME'.split(\"_\").map(&:capitalize).join()"`
BOOKING_REQUEST_NAME_SNAKE_PLURAL=`ruby -e "puts '$BOOKING_REQUEST_NAME' + 's'"`
BOOKING_REQUEST_NAME_CAMEL_PLURAL=`ruby -e "puts '$BOOKING_REQUEST_NAME'.split(\"_\").map(&:capitalize).join() + 's'"`

function replace_bookable_asset_and_booking_request_strings {
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

  echo > tmpfile_for_sed
  sed "s/booking_request/$BOOKING_REQUEST_NAME/g" $1 > tmpfile_for_sed
  mv tmpfile_for_sed $1

  echo > tmpfile_for_sed
  sed "s/BookingRequest/$BOOKING_REQUEST_NAME_CAMEL/g" $1 > tmpfile_for_sed
  mv tmpfile_for_sed $1

  echo > tmpfile_for_sed
  sed "s/BookingRequests/$BOOKING_REQUEST_NAME_CAMEL_PLURAL/g" $1 > tmpfile_for_sed
  mv tmpfile_for_sed $1

  echo > tmpfile_for_sed
  sed "s/booking_requests/$BOOKING_REQUEST_NAME_SNAKE_PLURAL/g" $1 > tmpfile_for_sed
  mv tmpfile_for_sed $1
}

echo "Setting up the booking request"
echo "Model name: $BOOKING_REQUEST_NAME, $BOOKING_REQUEST_NAME_CAMEL, $BOOKING_REQUEST_NAME_SNAKE_PLURAL"

#need to default status to :new
echo "booking_request migrations"
cd $APP_NAME
rails g model $BOOKING_REQUEST_NAME_CAMEL status first_name last_name email euid $BOOKABLE_ASSET_NAME:references
rake db:migrate
cd ..

echo "copy booking_request model"
cp booking_request_setup/booking_request.rb $APP_NAME/app/models/$BOOKING_REQUEST_NAME.rb
replace_bookable_asset_and_booking_request_strings $APP_NAME/app/models/$BOOKING_REQUEST_NAME.rb

echo "booking_request controller"
cp booking_request_setup/booking_requests_controller.rb $APP_NAME/app/controllers/$BOOKING_REQUEST_NAME_SNAKE_PLURAL'_controller'.rb
replace_bookable_asset_and_booking_request_strings $APP_NAME/app/controllers/$BOOKING_REQUEST_NAME_SNAKE_PLURAL'_controller'.rb

echo "booking_request views"
mkdir $APP_NAME/app/views/$BOOKING_REQUEST_NAME_SNAKE_PLURAL

echo "update user.rb"
cp booking_request_setup/user.rb $APP_NAME/app/models/user.rb
replace_bookable_asset_and_booking_request_strings $APP_NAME/app/models/user.rb

echo "update routes"
cp booking_request_setup/completed_routes.rb $APP_NAME/config/routes.rb

echo "generate active admin"
cd $APP_NAME
rails g active_admin:resource $BOOKING_REQUEST_NAME_CAMEL
cd ..

echo "add reference to order"
#make sure this works...
cd $APP_NAME
rails g migration Add$BOOKING_REQUEST_NAME_CAMEL'ToOrder' $BOOKING_REQUEST_NAME:references
rake db:migrate
cd ..

echo "update alerts partial, notify of new booking request"
cp booking_request_setup/alerts_partial.haml $APP_NAME/app/views/layouts/_alerts.haml
replace_bookable_asset_and_booking_request_strings $APP_NAME/app/views/layouts/_alerts.haml
