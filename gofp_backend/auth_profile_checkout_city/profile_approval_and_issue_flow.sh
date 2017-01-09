#depends on user and profile

APP_NAME=$1
if [ "$1" = "" ]; then
  echo "you need to give an app name"
  exit 1
fi

echo "Setting up profile approval + issue flow"

echo "mailer classes"
cp profile_approval_and_issue_flow/admin_mailer.rb $APP_NAME/app/mailers/admin_mailer.rb
cp profile_approval_and_issue_flow/profile_mailer.rb $APP_NAME/app/mailers/profile_mailer.rb
cp profile_approval_and_issue_flow/application_mailer.rb $APP_NAME/app/mailers/application_mailer.rb

echo "mailer views"
mkdir $APP_NAME/app/views/admin_mailer
mkdir $APP_NAME/app/views/profile_mailer
cp profile_approval_and_issue_flow/approval_notice.haml $APP_NAME/app/views/admin_mailer/approval_notice.haml
cp profile_approval_and_issue_flow/alert_user_of_profile_issue.haml $APP_NAME/app/views/profile_mailer/alert_user_of_profile_issue.haml
cp profile_approval_and_issue_flow/publish_notice_to_user.haml $APP_NAME/app/views/profile_mailer/publish_notice_to_user.haml

echo "update profile model"
cp profile_approval_and_issue_flow/profile.rb $APP_NAME/app/models/profile.rb

echo "update profiles_controller"
cp profile_approval_and_issue_flow/profiles_controller.rb $APP_NAME/app/controllers/profiles_controller.rb

echo "active_admin profile manager"
cd $APP_NAME
rails g active_admin:resource Profile
cd ..
cp profile_approval_and_issue_flow/profile_admin.rb $APP_NAME/app/admin/profile.rb

echo "update profile publish manager"
cp profile_approval_and_issue_flow/profile_publish_manager.rb $APP_NAME/lib/profile_publish_manager.rb


echo "issue migration"
cd $APP_NAME
rails g model Issue
cd ..
find $APP_NAME/db/migrate -name '*create_issues*' | xargs -I '{}' cp profile_approval_and_issue_flow/issues_migration.rb '{}'

echo "issue model"
cp profile_approval_and_issue_flow/issue.rb $APP_NAME/app/models

echo "active_admin issues"
cd $APP_NAME
rails g active_admin:resource Issue
cd ..
cp profile_approval_and_issue_flow/issue_admin.rb $APP_NAME/admin/issue.rb

echo "active admin issue form"
mkdir $APP_NAME/app/admin/views
cp profile_approval_and_issue_flow/create_issue_admin.haml $APP_NAME/admin/views/create_issue.haml

echo "finally rake db:migrate"
cd $APP_NAME
rake db:migrate
cd ..

echo "commiting"
cd $APP_NAME
git add .
git commit -m "updating profile, publish flow, approval flow, issues, admin"
cd ..

echo "all done then."


