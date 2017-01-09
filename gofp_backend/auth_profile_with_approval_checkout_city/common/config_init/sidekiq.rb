# Sidekiq.configure_client do |config|
#   config.redis = {:size=>1, :namespace => 'offlinedating' }
# end
#
# Sidekiq.configure_server do |config|
#   config.redis = {:size=>2, :namespace => 'offlinedating' }
#
#   #database_url = ENV['DATABASE_URL']
#   #sidekiq_concurrency = ENV['SIDEKIQ_CONCURRENCY']
#   #if(database_url && sidekiq_concurrency)
#   #  Rails.logger.debug("Setting custom connection pool size of #{sidekiq_concurrency} for Sidekiq Server")
#   #
#   #  ENV['DATABASE_URL'] = "#{database_url}?pool=#{sidekiq_concurrency}"
#   #  Rails.logger.debug(%Q(DATABASE_URL => "#{ENV['DATABASE_URL']}"))
#   #
#   #  ActiveRecord::Base.establish_connection
#   #end
#   #
#   #Rails.logger.info("Connection Pool size for Sidekiq Server is now: #{ActiveRecord::Base.connection.pool.instance_variable_get('@size')}")
# end
