#ASSUMES USER MODEL EXISTS

APP_NAME=$1
if [ "$1" = "" ]; then
  echo "you need to give an app name"
  exit 1
fi

echo "setting up cities for $APP_NAME"

echo "view_js :city_validation"
cp -r city_selection/city_validation.js.coffee $APP_NAME/app/assets/javascripts/view_js

echo "include cities in user controller"
cp city_selection/users_controller.rb $APP_NAME/app/controllers/users_controller.rb

echo "include cities in application controller"
cp city_selection/application_controller.rb $APP_NAME/app/controllers/application_controller.rb

echo "citypicker.js.coffee to main js"
cp -r city_selection/citypicker.js.coffee $APP_NAME/app/assets/javascripts

echo "cities.yml to config"
cp -r city_selection/cities.yml $APP_NAME/config

echo "cities.rb to initializers"
cp -r city_selection/cities.rb $APP_NAME/config/initializers

echo "city confirmity policy"
cp city_selection/city_conformity_policy.rb $APP_NAME/lib

echo "update devise registration with city"
cp city_selection/devise_registration.rb $APP_NAME/app/controllers/users/registrations_controller.rb

echo "add city helper"
cp city_selection/city_helper.rb $APP_NAME/app/helpers

echo "city migration to user"
cd $APP_NAME
rails g migration AddCityToUser city
rake db:migrate
cd ..

echo "update user model!"
cp city_selection/user.rb $APP_NAME/app/models/user.rb
