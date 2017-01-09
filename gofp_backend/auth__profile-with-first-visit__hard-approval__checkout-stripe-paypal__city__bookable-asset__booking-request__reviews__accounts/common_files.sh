#as set up, will have to run this from richards_rails_template directory, and create your new rails app in that directory before moving it.

APP_NAME=$1
if [ "$1" = "" ]; then
  echo "you need to give an app name"
  exit 1
fi

CAPITALIZED_APP_NAME=`ruby -e "puts '$APP_NAME'.capitalize"`
echo "setting up common files for $APP_NAME"

#could add the rails new command, but want to cut it off when it tries to do bundle install.

#gemfile
echo "copying Gemfile"
cp gemfile $APP_NAME/Gemfile

#bundle gemfile
echo "bundling install"
cd $APP_NAME
bundle install
cd ..


#database.yml
echo "database.yml"
cp common/config_init/database.yml $APP_NAME/config/database.yml
echo > tmpfile_for_sed
sed "s/boilerplate/$APP_NAME/g" $APP_NAME/config/database.yml > tmpfile_for_sed
mv tmpfile_for_sed $APP_NAME/config/database.yml
echo "switched out boilerplate with $APP_NAME"

echo "lets set up the db"
echo "**************************************************"
echo "running Postgres.app command to create role; make sure it's in your PATH"
createuser $APP_NAME -d -l
echo "done"
echo "**************************************************"

#make sure 'boilerplate' is replaced first so get proper DB names
echo "setting up the DB, rake db:migrate db:setup"
cd $APP_NAME
rake db:setup
rake db:migrate
cd ..

#application.rb file
echo "application.rb file *** change out 'boilerplate'"
cp common/config_init/application.rb $APP_NAME/config/application.rb
echo "replacing module name with app name"
echo "doublcheck if you have underscores in your app name"
echo > tmpfile_for_sed
sed "s/Boilerplate/$CAPITALIZED_APP_NAME/g" $APP_NAME/config/application.rb > tmpfile_for_sed
mv tmpfile_for_sed $APP_NAME/config/application.rb


#Procfile
echo "Procfile"
cp common/config_init/Procfile $APP_NAME

#Guardfile
echo "Guardfile"
cp common/config_init/Guardfile $APP_NAME

#Unicorn
echo "Unicorn"
cp common/config_init/unicorn.rb $APP_NAME/config

#images
echo "copying images"
cp -r common/images/ $APP_NAME/app/assets/images

#css
echo "remove default css manifest"
rm $APP_NAME/app/assets/stylesheets/application.css
echo "copying stylesheets, font.css.scss too"
cp -r common/css/ $APP_NAME/app/assets/stylesheets

#js
echo "remove default js manifest"
rm $APP_NAME/app/assets/javascripts/application.js
echo "copying javascripts"
cp -r common/js/ $APP_NAME/app/assets/javascripts

#fonts
echo "copy fonts"
mkdir $APP_NAME/app/assets/fonts
cp -r common/fonts/ $APP_NAME/app/assets/fonts

#layouts
echo "replace layouts"
rm $APP_NAME/app/views/layouts/application.html.erb
cp -r common/layouts/ $APP_NAME/app/views/layouts

#application helper and controller
echo "copying/ overwriting application_controller and application_helper"
cp common/app_controller_helper/application_controller.rb $APP_NAME/app/controllers/application_controller.rb
cp common/app_controller_helper/application_helper.rb $APP_NAME/app/helpers/application_helper.rb
echo > tmpfile_for_sed
sed "s/bookable_asset/$APP_NAME/g" $APP_NAME/app/helpers/application_helper.rb > tmpfile_for_sed
mv tmpfile_for_sed $APP_NAME/app/helpers/application_helper.rb


#Active Job
echo "active job file"
cp common/config_init/active_job.rb $APP_NAME/config/initializers

#lib
echo "set up generic lib"
cp -r common/lib/ $APP_NAME/lib

#helpers
echo "some helpers"
cp -r common/helpers/ $APP_NAME/app/helpers

#misc folders in app/
echo "add folders for decorators, serializers, workers"
mkdir $APP_NAME/app/decorators
mkdir $APP_NAME/app/serializers
mkdir $APP_NAME/app/workers

#Paperclip
echo "adding paperclip"
cp common/config_init/paperclip.rb $APP_NAME/config/initializers

#AWS
echo "adding aws config"
cp common/config_init/aws.yml $APP_NAME/config
echo "change out 'boilerplate' on aws"
echo > tmpfile_for_sed
sed "s/boilerplate/$APP_NAME/g" $APP_NAME/config/aws.yml > tmpfile_for_sed
mv tmpfile_for_sed $APP_NAME/config/aws.yml

#basic locales strucutre
echo "locales basic structure"
rm $APP_NAME/config/locales/en.yml
cp -r common/locales/ $APP_NAME/config/locales


#better environemnts config
echo "better environment/ files"
rm -rf $APP_NAME/config/environments/
mkdir $APP_NAME/config/environments
cp -r common/environments/ $APP_NAME/config/environments


#sidekiq?
echo "sample sidekiq initializer"
cp common/config_init/sidekiq.rb $APP_NAME/config/initializers

#welcome setup (controller, views)
echo "adding welcome controller and views"
cp common/welcome/welcome_controller.rb $APP_NAME/app/controllers
cp -r common/welcome/welcome $APP_NAME/app/views

#shared/ error messages
echo "error messages logic, shared folder"
mkdir $APP_NAME/app/views/shared
cp common/misc_haml/_error_messages.haml $APP_NAME/app/views/shared

#basic mailer
echo "basic admin mailer"
cd $APP_NAME
rails g mailer AdminMailer --no-test-framework
cd ..


#all the testing section stuff
echo "add integration_test_helper.rb"
cp common/tests/integration_test_helper.rb $APP_NAME/test
echo "add test_case"
cp common/tests/test_case.rb $APP_NAME/test
echo "add test_helper"
cp common/tests/test_helper.rb $APP_NAME/test
echo "add navigation"
cp -r common/tests/integration/ $APP_NAME/test/integration
echo "add facotries"
cp common/tests/factories.rb $APP_NAME/test
echo "fixture image"
cp -r common/tests/fixtures/ $APP_NAME/test/fixtures

#internal pages
echo "adding internal pages - color palette stuff"
mkdir $APP_NAME/app/views/internal_pages
cp common/internal_pages/internal_pages_controller.rb $APP_NAME/app/controllers
cp common/internal_pages/color_palette.haml $APP_NAME/app/views/internal_pages

echo "adding sample policies"
mkdir $APP_NAME/app/views/policies
cp -r common/policies/ $APP_NAME/app/views/policies
cp common/internal_pages/policies.haml $APP_NAME/app/views/layouts
cp common/internal_pages/policies_controller.rb $APP_NAME/app/controllers

echo "basic routes file"
cp common/routes.rb $APP_NAME/config/routes.rb

echo "add generic mvc generator, rich style"
cp ../generic_mvc_generators/generic_view_form_controller_skippable.rake $APP_NAME/lib/tasks

echo "add extra component generators (rake tasks). Includes search_with_homepage_hook, "
cp ../component_generators/search_with_homepage_hook.rake $APP_NAME/lib/tasks

echo "add site subscriptions"
cd $APP_NAME
rails g model SiteSubscription email
cd ..
cp common/site_subscriptions/site_subscription.rb $APP_NAME/app/models
cp common/site_subscriptions/site_subscriptions_controller.rb $APP_NAME/app/controllers

#final cleaning up of crap...
echo "TODO get rid clutter"

echo "failsafe rake db:migrate"
cd $APP_NAME
rake db:migrate
cd ..

echo "all done with common setup stuff"
