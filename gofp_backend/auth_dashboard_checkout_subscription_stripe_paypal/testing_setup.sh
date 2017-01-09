#NOTE a lot of testing already setup in common_setup

APP_NAME=$1
if [ "$1" = "" ]; then
  echo "you need to give an app name"
  exit 1
fi

CAPITALIZED_APP_NAME=`ruby -e "puts '$APP_NAME'.capitalize"`

echo "copy minimal factories.rb"
cp testing/factories.rb $APP_NAME/test


echo "All done with testing!"
