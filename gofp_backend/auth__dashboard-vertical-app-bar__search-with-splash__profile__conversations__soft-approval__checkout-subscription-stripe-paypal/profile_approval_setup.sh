APP_NAME=$1
if [ "$1" = "" ]; then
  echo "you need to give an app name"
  exit 1
fi

echo "adding profile approval (soft)"


echo "active_admin profile manager"
cd $APP_NAME
rails g active_admin:resource Profile
cd ..
cp profile_approval/profile_admin.rb $APP_NAME/app/admin/profile.rb

echo "issue migration"
cd $APP_NAME
rails g model Issue
cd ..
find $APP_NAME/db/migrate -name '*create_issues*' | xargs -I '{}' cp profile_approval/issue_migration.rb '{}'

echo "issue model"
cp profile_approval/issue.rb $APP_NAME/app/models

echo "active_admin issues"
cd $APP_NAME
rails g active_admin:resource Issue
cd ..
cp profile_approval/issue_admin.rb $APP_NAME/app/admin/issue.rb

echo "active admin issue form"
mkdir $APP_NAME/app/admin/views
cp profile_approval/create_issue_admin.haml $APP_NAME/app/admin/views/create_issue.haml

echo "profile publish manager"
cp profile_approval/profile_publish_manager.rb $APP_NAME/lib/

echo "migrate for good measure"
cd $APP_NAME
rake db:migrate
cd ..
