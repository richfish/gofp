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

echo "add mailer rubies"
cp -r all_mailers/mailer_ruby/ $APP_NAME/app/mailers/
cp all_mailers/bookable_asset_mailer.rb $APP_NAME/app/mailers/$BOOKABLE_ASSET_NAME'_mailer.rb'
for f in $APP_NAME/app/mailers/*
do
  replace_bookable_asset_and_booking_request_strings $f
  echo "replacing strings in ruby file: $f"
done

echo "add mailer hamls"
cp -r all_mailers/mailer_haml/ $APP_NAME/app/views/
mkdir $APP_NAME/app/views/$BOOKABLE_ASSET_NAME'_mailer'
cp -r all_mailers/bookable_asset_mailer/ $APP_NAME/app/views/$BOOKABLE_ASSET_NAME'_mailer'
#be careful with the below
for f in $APP_NAME/app/views/admin_mailer/* $APP_NAME/app/views/profile_mailer/* $APP_NAME/app/views/conversation_mailer/* $APP_NAME/app/views/review_mailer/* $APP_NAME/app/views/$BOOKABLE_ASSET_NAME'_mailer'/* $APP_NAME/app/views/user_mailer/*
do
  replace_bookable_asset_and_booking_request_strings $f
  echo "replacing strings in haml file: $f"
done

echo "prune stubborn sed tmpfiles"
cd $APP_NAME
find . -name "tmpfile_for_sed" | xargs -t rm
cd ..
