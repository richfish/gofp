APP_NAME=$1
if [ "$1" = "" ]; then
  echo "you need to give an app name"
  exit 1
fi

echo "adding search (non home page hook)"

echo "search views"
mkdir $APP_NAME/app/views/search_entities
cp -r search/views/ $APP_NAME/app/views/searchable_entities

echo "search css"
cp search/searchable_entity.css.sass $APP_NAME/app/assets/stylesheets/
cp search/search_and_filtering.css.sass $APP_NAME/app/assets/stylesheets/

echo "search helper"
cp search/search_helper.rb $APP_NAME/app/helpers/

echo "search js"
cp search/search_page.js.coffee $APP_NAME/app/assets/javascripts/view_js/

echo "search manager"
cp search/search_manager.rb $APP_NAME/lib/

echo "search controller"
cp search/searchable_entities_controller.rb $APP_NAME/app/controllers/

echo "search entity subscription stuff"
cp search/search_entity_subscriptions_controller.rb $APP_NAME/app/controllers/
cd $APP_NAME
rails g model SearchEntitySubscription email
rake db:migrate
cd ..
cp search/search_entity_subscription.rb $APP_NAME/app/models/
