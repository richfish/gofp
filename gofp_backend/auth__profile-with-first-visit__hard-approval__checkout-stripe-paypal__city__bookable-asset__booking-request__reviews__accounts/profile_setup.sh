#obviously this depends on having user set up

APP_NAME=$1
if [ "$1" = "" ]; then
  echo "you need to give an app name"
  exit 1
fi

echo "setting up profile for $APP_NAME"

echo "add JS"
cp profile_setup/profile.js.coffee $APP_NAME/app/assets/javascripts/view_js

echo "add css"
cp profile_setup/profile.css.sass $APP_NAME/app/assets/stylesheets

echo "add relevant haml"
mkdir $APP_NAME/app/views/profiles
cp -r profile_setup/views/ $APP_NAME/app/views/profiles

echo "add decorator"
cp profile_setup/profile_decorator.rb $APP_NAME/app/decorators

echo "add profile helper"
cp profile_setup/profile_helper.rb $APP_NAME/app/helpers

echo "adding default avatar image"
cp profile_setup/missing.png $APP_NAME/app/assets/images
cp profile_setup/missing.png $APP_NAME/app/assets/images/missing2.png

echo "add profile migration"
cd $APP_NAME
rails g model Profile first_name last_name status flagged:boolean user:references
rake db:migrate
cd ..
#set some defaults? flagged/ status/ etc.

echo "add profile model"
cp profile_setup/profile.rb $APP_NAME/app/models/profile.rb

echo "add asset image migrations, files, & paperclip"
cd $APP_NAME
#make sure polymorphic works...
rails g model Asset caption owner:references{polymoprhic}
cd ..
find $APP_NAME/db/migrate -name '*create_assets*' | xargs -I '{}' cp profile_setup/asset_migration.rb '{}'
cd $APP_NAME
rake db:migrate
rails g paperclip asset image
rake db:migrate
cd ..
cp profile_setup/asset.rb $APP_NAME/app/models/
cp profile_setup/asset_images.js.coffee $APP_NAME/app/assets/javascripts/view_js/


echo "add profiles controller"
cp profile_setup/profiles_controller.rb $APP_NAME/app/controllers

echo "update routes"
cp profile_setup/completed_routes.rb $APP_NAME/config/routes.rb

echo "update user model!"
cp profile_setup/user.rb $APP_NAME/app/models


echo "adding default status to profile"
cd $APP_NAME
rails g migration AddDefaultStatusToProfile
cd ..
find $APP_NAME/db/migrate -name '*add_default_status_to_profile*' | xargs -I '{}' cp profile_setup/add_default_status_to_profile.rb '{}'
cd $APP_NAME
echo "migrating again adding default status"
rake db:migrate
cd ..
