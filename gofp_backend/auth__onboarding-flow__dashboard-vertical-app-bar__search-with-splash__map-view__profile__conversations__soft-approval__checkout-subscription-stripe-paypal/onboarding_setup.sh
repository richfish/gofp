APP_NAME=$1
if [ "$1" = "" ]; then
  echo "you need to give an app name"
  exit 1
fi

echo "adding onboarding"

echo "adding landing page partial"
cp onboarding/_onboarding_cta.haml $APP_NAME/app/views/welcome

echo "views"
mkdir $APP_NAME/app/views/onboardings
cp -r onboarding/views/ $APP_NAME/app/views/onboardings/

echo "layout"
cp onboarding/onboarding.haml $APP_NAME/app/views/layouts/

echo "layout header"
cp onboarding/_header_onboarding.haml $APP_NAME/app/views/layouts/

echo "controller"
cp onboarding/onboardings_controller.rb $APP_NAME/app/controllers/

echo "stylesheets"
cp onboarding/onboarding.css.sass $APP_NAME/app/assets/stylesheets/

echo "javascripts"
cp onboarding/onboarding.js.coffee $APP_NAME/app/assets/javascripts/view_js/

echo "helper"
cp onboarding/onboarding_helper.rb $APP_NAME/app/helpers/
