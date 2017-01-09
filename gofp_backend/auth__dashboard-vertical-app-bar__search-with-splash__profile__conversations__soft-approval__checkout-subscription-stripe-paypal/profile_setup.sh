APP_NAME=$1
if [ "$1" = "" ]; then
  echo "you need to give an app name"
  exit 1
fi

echo "adding profile"

# echo "add JS"
# cp profile/profile.js.coffee $APP_NAME/app/assets/javascripts/view_js

echo "add css"
cp profile/profile.css.sass $APP_NAME/app/assets/stylesheets

echo "add haml"
mkdir $APP_NAME/app/views/profiles
cp -r profile/views/ $APP_NAME/app/views/profiles

echo "add decorator"
cp profile/profile_decorator.rb $APP_NAME/app/decorators

echo "add profile helper"
cp profile/profile_helper.rb $APP_NAME/app/helpers

echo "adding default avatar image"
cp profile/missing.png $APP_NAME/app/assets/images
cp profile/missing.png $APP_NAME/app/assets/images/missing2.png

echo "add profile migration"
cd $APP_NAME
rails g model Profile first_name last_name status flagged:boolean user:references
rake db:migrate
cd ..

echo "add profile model"
cp profile/profile.rb $APP_NAME/app/models/profile.rb


echo "add asset image migrations, files, & paperclip"
cd $APP_NAME
#make sure polymorphic works...
rails g model Asset caption owner:references{polymoprhic}
cd ..
find $APP_NAME/db/migrate -name '*create_assets*' | xargs -I '{}' cp profile/asset_migration.rb '{}'
cd $APP_NAME
rake db:migrate
rails g paperclip asset image
rake db:migrate
cd ..
cp profile/asset.rb $APP_NAME/app/models/
cp profile/asset_images.js.coffee $APP_NAME/app/assets/javascripts/view_js/


echo "add profiles controller"
cp profile/profiles_controller.rb $APP_NAME/app/controllers

echo "update user model!"
cp profile/user.rb $APP_NAME/app/models
