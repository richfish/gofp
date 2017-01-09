#contains vertical app bar

APP_NAME=$1
if [ "$1" = "" ]; then
  echo "you need to give an app name"
  exit 1
fi

echo "copy dashboard template"
cp dashboard/dashboard_template.haml $APP_NAME/app/views/users/_dashboard.haml

echo "copy new application.haml layout"
cp dashboard/application.haml $APP_NAME/app/views/layouts/application.haml

echo "dashboard view_js"
cp dashboard/dashboard.js.coffee $APP_NAME/app/assets/javascripts/view_js/

echo "vertical app bar"
cp dashboard/_vertical_app_bar.haml $APP_NAME/app/views/layouts/
