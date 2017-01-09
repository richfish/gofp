Devise::Async.setup do |config|
  config.enabled = !Rails.env.test? #due to devise-async using after_commit hooks and tests are using transaction db cleaner
  config.backend = :sidekiq
  config.queue   = :default
end