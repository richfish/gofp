#post setup redirects to generic dashboard page, that hs some filler whatever content

APP_NAME=$1
if [ "$1" = "" ]; then
  echo "you need to give an app name"
  exit 1
fi

echo "copy dashboard template"
cp dashboard/dashboard_template.haml $APP_NAME/app/views/users/_dashboard.haml

echo "Setting up Dashboard for $APP_NAME"
