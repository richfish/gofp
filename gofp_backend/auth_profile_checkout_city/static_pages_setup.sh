APP_NAME=$1
if [ "$1" = "" ]; then
  echo "you need to give an app name"
  exit 1
fi

echo "Adding basic static pages, inc. sample 'policies'"

echo "css"
cp static_pages_setup/policies.css.sass $APP_NAME/app/assets/stylesheets

echo "controller"
cp static_pages_setup/static_pages_controller.rb $APP_NAME/app/controllers

echo "view set"
mkdir $APP_NAME/app/views/static_pages
cp -r static_pages_setup/views/ $APP_NAME/app/views/static_pages

echo "update footer links"
cp static_pages_setup/footer_content.haml $APP_NAME/app/views/layouts/_footer_welcome.haml

echo "udpate routes"
cp static_pages_setup/routes_complete.rb $APP_NAME/config/routes.rb

echo "add to git"
cd $APP_NAME
git add .
git commit -m "adding generic policies/ static pages"
cd ..

echo "all done then"