#assumes html2haml has been bundled and is there
#Set ups ActiveAdmin too
#Sets up User Account boiler too
#copies routes file when done with EVERYTHING minus payments
#only for 'User' model ATM
#TODO abstract to any model name for 'User'

APP_NAME=$1
if [ "$1" = "" ]; then
  echo "you need to give an app name"
  exit 1
fi

echo "Setting up Devise for $APP_NAME"
echo "NOTE: by default we are adding confirmable;"

echo "basic installation"
echo "may have already been done with active admin setup..."
cd $APP_NAME
rails generate devise:install
cd ..

echo "initializer settings"
cp devise_setup/devise.rb $APP_NAME/config/initializers


echo "generate for model"
cd $APP_NAME
rails generate devise User
cd ..

echo "use migration file with confirmable"
#make sure this works...
find $APP_NAME/db/migrate -name '*devise*' | xargs -I '{}' cp devise_setup/devise_migration.rb '{}'

echo "migrate the db"
cd $APP_NAME
rake db:migrate
cd ..

echo "copy model file"
cp devise_setup/user.rb $APP_NAME/app/models


#active admin basics
echo "********adding active_admin*********"
cd $APP_NAME
rails g active_admin:install
rake db:migrate
cd ..
cp active_admin/seeds.rb $APP_NAME/db/seeds.rb
cp active_admin/active_admin.rb $APP_NAME/config/initializers
cp active_admin/active_admin.css.scss $APP_NAME/app/assets/stylesheets
cp active_admin/active_admin.js.coffee $APP_NAME/app/assets/javascripts
echo "rake seed"
cd $APP_NAME
rake db:seed
cd ..
echo "done active admin - back to more devise"

echo "active_admin user"
cd $APP_NAME
rails g active_admin:resource User
cd ..

echo "expose views for default"
cd $APP_NAME
rails generate devise:views
cd ..

echo "expose views for model"
cd $APP_NAME
rails generate devise:views users
cd ..

echo "expose controllers"
cd $APP_NAME
rails generate devise:controllers users
cd ..

echo "change erb to haml"
cd $APP_NAME
find . -name \*.erb -print | sed 'p;s/.erb$/.haml/' | xargs -n2 html2haml
cd ..

echo "prune erb files"
cd $APP_NAME
find . -name "*.erb" | xargs -t rm
cd ..

echo "login/signup haml i.e. session#new and registration#new, shared links, confirmations"
cp devise_setup/new_session.haml $APP_NAME/app/views/users/sessions/new.html.haml
cp devise_setup/new_registration.haml $APP_NAME/app/views/users/registrations/new.html.haml
cp devise_setup/shared_links.haml $APP_NAME/app/views/users/shared/_links.html.haml

echo "set up custom #create action"
cp devise_setup/registrations_controller.rb $APP_NAME/app/controllers/users/registrations_controller.rb

echo "setting up devise async"
cp devise_setup/devise_async.rb $APP_NAME/config/initializers

echo "setting up routes with devise stuff"
cp devise_setup/complete_routes.rb $APP_NAME/config/routes.rb

echo "tweak welcome controller"
cp devise_setup/welcome_controller.rb $APP_NAME/app/controllers/welcome_controller.rb

echo "add links to header"
cp devise_setup/header.haml $APP_NAME/app/views/layouts/_header.haml


echo "********adding account stuff**************"
echo "adding users_controller"
cp user_account/users_controller.rb $APP_NAME/app/controllers
echo "set up edit show index user views"
#TODO pinpoint files to delete, html2haml etc
cp user_account/edit.haml $APP_NAME/app/views/users
cp user_account/index.haml $APP_NAME/app/views/users
cp user_account/show.haml $APP_NAME/app/views/users
cp user_account/provider_show.haml $APP_NAME/app/views/users/_provider_show.haml
echo "add account js"
cp user_account/account.js.coffee $APP_NAME/app/assets/javascripts/view_js
echo "add user decorator"
cp user_account/user_decorator.rb $APP_NAME/app/decorators


echo "OK done - you've added devise for the user, also active admin, final routes, and some user account logic"
