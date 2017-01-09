module ChildClassLoadingEntity
  extend ::ActiveSupport::Concern

  included do
    def self.load_child_classes (pattern, *ignore)
      Dir["#{Rails.root}/#{pattern}"].each do |file|
        next if ignore.include?(File.basename(file))
        require_dependency file rescue NameError
      end
    end

    def self.child_classes
      self.descendants.select { |x| not x.name.index("Abstract") }
    end
  end
end
