# #ASSUMES DEVISE HAS ALREADY RUN
#
#
# APP_NAME=$1
# if [ "$1" = "" ]; then
#   echo "you need to give an app name"
#   exit 1
# fi
#
# echo "setting up user account for $APP_NAME"
#
# echo "adding users_controller"
# cp user_account/users_controller.rb $APP_NAME/app/controllers
#
# echo "set up edit show index user views"
# #TODO pinpoint files to delete, html2haml etc
# cp user_account/edit.haml $APP_NAME/app/views/users
# cp user_account/index.haml $APP_NAME/app/views/users
# cp user_account/show.haml $APP_NAME/app/views/users
#
# echo "add account js"
# cp user_account/account.js.coffee $APP_NAME/app/assets/javascripts/view_js
