#make sure this goes after the search setup, needs to overwrite

APP_NAME=$1
if [ "$1" = "" ]; then
  echo "you need to give an app name"
  exit 1
fi

echo "adding google map view setup"
echo "this gives: a layout like sharedesk/ AirBnB; searching with google places + updating map center; map with assets/ popups overlayed"


echo "copy haml"
cp -r map_view/views/ $APP_NAME/app/views/searchable_entities/


echo "searchable entities controller"
cp map_view/searchable_entities_controller.rb $APP_NAME/app/controllers/searchable_entities_controller.rb

echo "update seeds"
cp map_view/seeds.rb $APP_NAME/db/seeds.rb
cd $APP_NAME
rake db:seed
cd ..

echo "already updates gemfile"

echo "update view_js"
mkdir $APP_NAME/app/assets/javascripts/view_js
cp -r map_view/view_js/ $APP_NAME/app/assets/javascripts/view_js/

echo "update view_css"
mkdir $APP_NAME/app/assets/stylesheets/view_css
cp -r map_view/view_css/ $APP_NAME/app/assets/stylesheets/view_css/

echo "update css"
cp map_view/search_and_filtering.css.sass $APP_NAME/app/assets/stylesheets/search_and_filtering.css.sass

echo "update/ append to manifest js"
echo '//= require underscore' >> $APP_NAME/app/assets/javascripts/application.js
echo '//= require gmaps/google' >> $APP_NAME/app/assets/javascripts/application.js
  

echo "should be done with mapview!"
