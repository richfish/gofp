class ApplicationMailer < ActionMailer::Base
  default from: "from@monkey.com"
  layout 'global_mailer'
end
