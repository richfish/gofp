APP_NAME=$1
if [ "$1" = "" ]; then
  echo "you need to give an app name"
  exit 1
fi

echo "Copying final routes for $APP_NAME"
cp final/final_routes.rb $APP_NAME/config/routes.rb

echo "Copying final user.rb"
cp final/user.rb $APP_NAME/app/models/user.rb

echo "Copying final mailers"
cp -r final/all_mailers/mailer_views/ $APP_NAME/app/views/
cp -r final/all_mailers/mailers/ $APP_NAME/app/mailers/

echo "Copying asset and js manifests"
cp final/application.css.sass $APP_NAME/app/assets/stylesheets/application.css.sass
cp final/application.js $APP_NAME/app/assets/javascripts/application.js

echo "Factories.rb file"
cp testing/factories.rb $APP_NAME/test

echo "Done with final file setups"

#maybe add headers too? layout files
