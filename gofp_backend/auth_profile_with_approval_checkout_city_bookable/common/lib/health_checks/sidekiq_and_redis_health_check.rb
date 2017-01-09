module HealthChecks
  module Base
    class SidekiqAndRedisHealthCheck < HealthChecks::Base::HealthCheck

      def check
        connected_clients_min = 2
        redis_info = Sidekiq.redis { |conn| conn.info }

        connected_clients = redis_info['connected_clients'].to_i
        if connected_clients < connected_clients_min
          raise "connected_clients (including workers) are too few #{connected_clients} found, expected at least #{connected_clients_min}"
        end
      end

      def failure_notice
        "verify that the sidekiq workers are running and that redis is up"
      end
    end
  end
end