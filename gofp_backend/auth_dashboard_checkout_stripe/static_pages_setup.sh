APP_NAME=$1
if [ "$1" = "" ]; then
  echo "you need to give an app name"
  exit 1
fi

echo "Adding basic static pages, inc. sample 'policies'"

echo "css"
cp static_pages_setup/policies.css.sass $APP_NAME/app/assets/stylesheets

echo "udpate routes"
cp static_pages_setup/routes_complete.rb $APP_NAME/config/routes.rb

echo "all done then"
