APP_NAME=$1
if [ "$1" = "" ]; then
  echo "you need to give an app name"
  exit 1
fi

echo "Copying final routes for $APP_NAME"

cp final_routes.rb $APP_NAME/config/routes.rb
