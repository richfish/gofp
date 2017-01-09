APP_NAME=$1
if [ "$1" = "" ]; then
  echo "you need to give an app name"
  exit 1
fi

echo "adding conversation"

echo "conversation views"
mkdir $APP_NAME/app/views/conversations
cp -r conversation/views/ $APP_NAME/app/views/conversations/

echo "conversation css"
cp conversation/conversation.css.sass $APP_NAME/app/assets/stylesheets/

echo "conversation decorator"
cp conversation/conversation_decorator.rb $APP_NAME/app/decorators
cp conversation/comment_decorator.rb $APP_NAME/app/decorators

echo "conversation controller"
cp conversation/conversations_controller.rb $APP_NAME/app/controllers/

echo "comment views"
mkdir $APP_NAME/app/views/comments
cp conversation/_comments.haml $APP_NAME/app/views/comments/
cp conversation/_comment.haml $APP_NAME/app/views/comments/

echo "conversation migration/ model"
cd $APP_NAME
rails g model Conversation converser_id:integer conversant_id:integer flagged:boolean comments_count:integer
cd ..
cp conversation/conversation.rb $APP_NAME/app/models/conversation.rb

echo "comments migration/ model"
cd $APP_NAME
rails g model Comment
cd ..
find $APP_NAME/db/migrate -name '*create_comments*' | xargs -I '{}' cp conversation/comment_migration.rb '{}'
cp conversation/comment.rb $APP_NAME/app/models/comment.rb

cd $APP_NAME
rake db:migrate
cd ..
