#!/bin/bash

#FOR NOW - DON'T RUN THIS SCRIPT, JUST COPY PARTS FROM IT AS NEEDED

#STILL TO DO
#setup github private repo + remote via API
#curl -u 'USERNAME' https://api.github.com/user/repos -d '{"name":"REPONAME"}'


APP_NAME=$1
HEROKU_STAGING=$1-staging
HEROKU_PRODUCTION=$1-production

#for now just production, no staging

heroku apps:create $HEROKU_PRODUCTION

heroku addons:add heroku-postgresql -a $HEROKU_PRODUCTION
heroku addons:add pgbackups -a $HEROKU_PRODUCTION

heroku addons:add rediscloud -a $HEROKU_PRODUCTION
heroku config:set REDIS_PROVIDER=REDISCLOUD_URL -a $HEROKU_PRODUCTION

heroku config:set RACK_ENV=production RAILS_ENV=production -a $HEROKU_PRODUCTION

heroku addons:add scheduler -a $HEROKU_PRODUCTION

heroku addons:add sendgrid:starter -a $HEROKU_PRODUCTION

heroku addons:add logentries -a $HEROKU_PRODUCTION

#go generate rollbar.rb inside heroku interface
heroku addons:add rollbar -a $HEROKU_PRODUCTION

heroku addons:add blitz -a $HEROKU_PRODUCTION

heroku addons:add newrelic:stark -a $HEROKU_PRODUCTION

#DO NOT SET THIS FOR PRODUCTION, GO INTO STRIPE ACCOUNT TO GET ACTUAL VALUES
# heroku config:set STRIPE_PUBLISHABLE_KEY=112341234134 -a $HEROKU_PRODUCTION
# heroku config:set STRIPE_SECRET_KEY=123412341234 -a $HEROKU_PRODUCTION

#GOOD STUFF ALSO
#add Google Analytics, and entry to Google business to get gmail. CName/ Namecheap/ MX config.

#git push heroku develop:master

#create AWS bucket for desired env.? (probably will be same as dev... unless you want to create a sep. account)
heroku config:set AWS_ACCESS_KEY_ID=your_access_key_id -a $HEROKU_PRODUCTION
heroku config:set AWS_SECRET_ACCESS_KEY=your_secret_access_key -a $HEROKU_PRODUCTION

#sidekiq
add to procfile --> worker: bundle exec sidekiq -C ./config/sidekiq.yml

#Different paypal credentials?


#ICEBOX
#repository on github or bitbucket??


