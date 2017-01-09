module HealthChecks
  module Base
    class HealthCheck
      include ChildClassLoadingEntity
      load_child_classes "lib/health_checks/*.rb"

      attr_accessor :status, :error_msg, :ms

    end
  end
end
