#!/bin/bash

#FOR NOW - DON'T RUN THIS SCRIPT, JUST COPY PARTS FROM IT AS NEEDED

#STILL TO DO
#setup github private repo + remote via API
#curl -u 'USERNAME' https://api.github.com/user/repos -d '{"name":"REPONAME"}'


APP_NAME=$1
HEROKU_staging=$1-staging
HEROKU_staging=$1-staging

#for now just staging, no staging

heroku apps:create littleboot-staging

heroku addons:create heroku-postgresql -a littleboot-staging
DEAD heroku addons:create pgbackups -a littleboot-staging

heroku addons:create rediscloud -a littleboot-staging
heroku config:set REDIS_PROVIDER=REDISCLOUD_URL -a littleboot-staging

heroku config:set RACK_ENV=production RAILS_ENV=production -a littleboot-staging

heroku addons:create scheduler -a littleboot-staging

#may need to add custom config file
heroku addons:create sendgrid:starter -a littleboot-staging

heroku addons:create logentries -a littleboot-staging


heroku addons:create airbrake:free_heroku -a littleboot-staging

#go generate rollbar.rb inside heroku interface
heroku addons:create rollbar -a littleboot-staging

heroku addons:create blitz -a littleboot-staging

#maybe skip, too annoying for tiny apps early stage
heroku addons:create newrelic:wayne -a littleboot-staging

#DO NOT SET THIS FOR staging, GO INTO STRIPE ACCOUNT TO GET ACTUAL VALUES
heroku config:set STRIPE_PUBLISHABLE_KEY=112341234134 -a littleboot-staging
heroku config:set STRIPE_SECRET_KEY=123412341234 -a littleboot-staging

#extra Devise
need to add a config.secret that deploying to heroku will give you

#secret token
need to add general secret token (rake secret), secrets.yml
>heroku config:set SECRET_KEY_BASE=112341234134

#GOOD STUFF ALSO
#add Google Analytics, and entry to Google business to get gmail. CName/ Namecheap/ MX config.

#git push heroku develop:master

#create AWS bucket for desired env.? (probably will be same as dev... unless you want to create a sep. account)
heroku config:set AWS_ACCESS_KEY_ID=your_access_key_id -a littleboot-staging
heroku config:set AWS_SECRET_ACCESS_KEY=your_secret_access_key -a littleboot-staging

#sidekiq
add to procfile --> worker: bundle exec sidekiq -C ./config/sidekiq.yml

#Different paypal credentials?

#multipack
$ heroku buildpacks:set https://github.com/ddollar/heroku-buildpack-multi.git

#Google Account stuff
# go to "More Controls > Domains" icon on the google admin page to add a new domain to your account; do a type: TXT host: @; val: google_provided on namecheap (or cloudflare) to verify; NOTE, try setting to 30 minutes TTL (or it takes a while to activate)
# Add new user from Users icon, follow prompt for new user to set up the email (may need to copy temp password)
# Catch all email forwarding: is called email alias (like sales@yada forwards to bill@yada... just for receiving); go to user page & scroll down to 'add alias'
# Add forwarding on gmail itself to go to rifisiherr

#Setting up domain
#In Heroku settings, add domains, both www and naked (or from CL, heroku domains:add www.example.com)
#In Namecheap

#SSL setup with Cloudfare - https://robots.thoughtbot.com/set-up-cloudflare-free-ssl-on-heroku
#Add website w/ free plan to cloudfare account
#Go to domain on namecheap, click edit name servers, enter custom records provided by Cloudfare...
#verify a day later that full SSL has been turned on (can happen quickly though)
#may need to modify DNS records like the thoughtbot entry..
#Also go into env files and config.force_ssl = true;
#make sure 'crypto' on cloudlfare section is set to full ssl, not flexible.


#SEO/ META TAGS
#rough guidelines: https://github.com/kpumuk/meta-tags

#custom Sendgrid formatting

#ICEBOX
#repository on github or bitbucket??
