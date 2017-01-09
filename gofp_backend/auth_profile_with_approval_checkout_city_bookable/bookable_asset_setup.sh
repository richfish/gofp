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
  sed "s/BookableAssets/$BOOKABLE_ASSET_NAME_SNAKE_PLURAL/g" $1 > tmpfile_for_sed
  mv tmpfile_for_sed $1
}


echo "Setting up the bookable asset"
echo "Model name: $BOOKABLE_ASSET_NAME, $BOOKABLE_ASSET_NAME_CAMEL, $BOOKABLE_ASSET_NAME_SNAKE_PLURAL"

echo "setup migrations for BookableAsset"
cd $APP_NAME
rails g model $BOOKABLE_ASSET_NAME_CAMEL status user:references date_and_time:datetime amount_cents:integer
rake db:migrate
cd ..

echo "copy model"
cp bookable_asset_setup/bookable_asset.rb $APP_NAME/app/models/$BOOKABLE_ASSET_NAME.rb
replace_bookable_asset_strings $APP_NAME/app/models/$BOOKABLE_ASSET_NAME.rb

echo "copy controller"
cp bookable_asset_setup/bookable_asset_controller.rb $APP_NAME/app/controllers/$BOOKABLE_ASSET_NAME_SNAKE_PLURAL'_controllers'.rb
replace_bookable_asset_strings $APP_NAME/app/controllers/$BOOKABLE_ASSET_NAME_SNAKE_PLURAL'_controllers'.rb

echo "bookable asset time manager"
cp bookable_asset_setup/bookable_asset_time_manager.rb $APP_NAME/lib/$BOOKABLE_ASSET_NAME'TimeManager.rb'
replace_bookable_asset_strings $APP_NAME/lib/$BOOKABLE_ASSET_NAME'TimeManager.rb'

echo "bookable asset mailer"
cp bookable_asset_setup/bookable_asset_mailer.rb $APP_NAME/app/mailers/$BOOKABLE_ASSET_NAME'_mailer.rb'
replace_bookable_asset_strings $APP_NAME/app/mailers/$BOOKABLE_ASSET_NAME'_mailer.rb'

echo "relevant background jobs"
cp bookable_asset_setup/workers/clear_expired_new_bookable_asset_job.rb $APP_NAME/app/workers/'clear_expired_new_'$BOOKABLE_ASSET_NAME'_job.rb'
cp bookable_asset_setup/workers/prepare_auto_cancellation_job.rb $APP_NAME/app/workers/prepare_auto_cancellation_job.rb
cp bookable_asset_setup/workers/prepare_complete_status_job.rb $APP_NAME/app/workers/prepare_complete_status_job.rb
cp bookable_asset_setup/workers/prompt_review_job.rb $APP_NAME/app/workers/prompt_review_job.rb
replace_bookable_asset_strings $APP_NAME/app/workers/'clear_expired_new_'$BOOKABLE_ASSET_NAME'_job.rb'
replace_bookable_asset_strings $APP_NAME/app/workers/prepare_auto_cancellation_job.rb
replace_bookable_asset_strings $APP_NAME/app/workers/prepare_complete_status_job.rb
replace_bookable_asset_strings $APP_NAME/app/workers/prompt_review_job.rb

echo "fee manager"
cp bookable_asset_setup/bookable_asset_fee_manager.rb $APP_NAME/lib/$BOOKABLE_ASSET_NAME'_fee_manager.rb'
replace_bookable_asset_strings $APP_NAME/lib/$BOOKABLE_ASSET_NAME'_fee_manager.rb'

echo "bookable asset css"
cp bookable_asset_setup/bookable_asset.css.sass $APP_NAME/app/assets/stylesheets/$BOOKABLE_ASSET_NAME'.css.sass'
replace_bookable_asset_strings $APP_NAME/app/assets/stylesheets

echo "helper methods"
cp bookable_asset_setup/bookable_asset_helper.rb $APP_NAME/app/helpers/$BOOKABLE_ASSET_NAME'_helper.rb'
replace_bookable_asset_strings $APP_NAME/app/helpers/$BOOKABLE_ASSET_NAME'_helper.rb'

echo "update routes"
cp bookable_asset_setup/routes.rb $APP_NAME/config/routes.rb
replace_bookable_asset_strings $APP_NAME/config/routes.rb

echo "basic views"
mkdir $APP_NAME/app/views/$BOOKABLE_ASSET_NAME_SNAKE_PLURAL
echo > $APP_NAME/app/views/$BOOKABLE_ASSET_NAME_SNAKE_PLURAL/new.haml
echo > $APP_NAME/app/views/$BOOKABLE_ASSET_NAME_SNAKE_PLURAL/show.haml
echo > $APP_NAME/app/views/$BOOKABLE_ASSET_NAME_SNAKE_PLURAL/index.haml
echo > $APP_NAME/app/views/$BOOKABLE_ASSET_NAME_SNAKE_PLURAL/_form.haml
echo > $APP_NAME/app/views/$BOOKABLE_ASSET_NAME_SNAKE_PLURAL/'_'$BOOKABLE_ASSET_NAME'_profile_show'
echo > $APP_NAME/app/views/$BOOKABLE_ASSET_NAME_SNAKE_PLURAL/_first_visit.haml

echo "update user profile view, view hook to bookable assets"
cp bookable_asset_setup/provider_show.haml $APP_NAME/app/views/users/_provider_show.haml
replace_bookable_asset_strings $APP_NAME/app/views/users/_provider_show.haml

echo "first visit view"
cp bookable_asset_setup/first_visit.haml $APP_NAME/app/views/$BOOKABLE_ASSET_NAME_CAMEL_PLURAL/_first_visit.haml
replace_bookable_asset_strings $APP_NAME/app/views/$BOOKABLE_ASSET_NAME_CAMEL_PLURAL/_first_visit.haml

echo "sample bootcamp form"
cp bookable_asset_setup/form.haml $APP_NAME/app/views/$BOOKABLE_ASSET_NAME_CAMEL_PLURAL/_form.haml
replace_bookable_asset_strings $APP_NAME/app/views/$BOOKABLE_ASSET_NAME_CAMEL_PLURAL/_form.haml

echo "view js"
cp bookable_asset_setup/bookable_asset.js.coffee $APP_NAME/app/assets/javascripts/view_js/$BOOKABLE_ASSET_NAME'.js.coffee'

echo "autocancellation policy"
cp bookable_asset_setup/auto_cancellation_policy.rb $APP_NAME/lib

echo "update alerts partial, notify of new booking"
cp bookable_asset_setup/alerts_partial.haml $APP_NAME/app/views/layouts/_alerts.haml
replace_bookable_asset_strings $APP_NAME/app/views/layouts/_alerts.haml

echo "add generic bookable_assets actions controller"
cp bookable_asset_setup/bookable_asset_actions_controller.rb $APP_NAME/app/controllers/$BOOKABLE_ASSET_NAME'_actions_controllers'.rb
replace_bookable_asset_strings $APP_NAME/app/controllers/$BOOKABLE_ASSET_NAME'_actions_controllers'.rb

echo "check into source control"
cd $APP_NAME
git add .
git commit -m "$BOOKABLE_ASSET_NAME flow"
cd ..

echo "all done here"


