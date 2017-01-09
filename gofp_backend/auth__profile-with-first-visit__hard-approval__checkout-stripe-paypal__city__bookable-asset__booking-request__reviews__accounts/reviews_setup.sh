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


echo "****setting up reviews****"

#this is going to add some sample fields, you should change them later.
echo "migration"
cd $APP_NAME
rails g model Review teaching_ability:integer value_of_experience:integer satisfaction:integer overall:integer private_message:text flagged:boolean acknowledged:boolean synopsis:text user:references $BOOKABLE_ASSET_NAME:references
rake db:migrate
cd ..

echo "model"
cp reviews_setup/review.rb $APP_NAME/app/models/review.rb
replace_bookable_asset_and_booking_request_strings $APP_NAME/app/models/review.rb

echo "admin"
cd $APP_NAME
  rails g active_admin:resource Review
cd ..
cp reviews_setup/admin_review.rb $APP_NAME/app/admin

echo "views"
mkdir $APP_NAME/app/views/reviews
cp -r reviews_setup/haml/ $APP_NAME/app/views/reviews/
for f in $APP_NAME/app/views/reviews/*
do
  replace_bookable_asset_and_booking_request_strings $f
  echo "copying strings in: $f"
done

echo "controller"
cp reviews_setup/reviews_controller.rb $APP_NAME/app/controllers/reviews_controller.rb
replace_bookable_asset_and_booking_request_strings $APP_NAME/app/controllers/reviews_controller.rb

echo "decorator"
cp reviews_setup/review_decorator.rb $APP_NAME/app/decorators/review_decorator.rb
replace_bookable_asset_and_booking_request_strings $APP_NAME/app/decorators/review_decorator.rb

echo "helpers"
cp reviews_setup/review_helper.rb $APP_NAME/app/helpers/review_helper.rb

echo "javascript"
cp reviews_setup/reviews.js.coffee $APP_NAME/app/assets/javascripts/view_js/

echo "stylesheets"
cp reviews_setup/reviews.css.sass $APP_NAME/app/assets/stylesheets/transparency_and_reviews.css.ass
cp reviews_setup/levels.css.sass $APP_NAME/app/assets/stylesheets/levels.css.sass

echo "update routes"
cp reviews_setup/completed_routes.rb $APP_NAME/config/routes.rb



