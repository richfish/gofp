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

echo "add profile_publish_manager"
cp profile_setup/profile_publish_manager.rb $APP_NAME/lib

echo "adding default avatar image"
cp profile_setup/missing.png $APP_NAME/app/assets/images

echo "add profile migration"
cd $APP_NAME
rails g model Profile first_name last_name status flagged:boolean user:references
rake db:migrate
cd ..
#set some defaults? flagged/ status/ etc.

#do something with paperclip??
echo "add paperclip avatar"
cd $APP_NAME
rails generate paperclip profile avatar
rake db:migrate
cd ..

echo "add profile model"
cp profile_setup/profile.rb $APP_NAME/app/models/profile.rb

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

echo "add to git"
cd $APP_NAME
git add .
git commit -m "adding profile, avatar/ image logic"
cd ..

echo "All done then."


