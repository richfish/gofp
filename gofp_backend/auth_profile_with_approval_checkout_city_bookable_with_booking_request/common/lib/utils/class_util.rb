class ClassUtil
  def self.class_or_superclass(obj)
    klass = obj.is_a?(Class) ? obj : obj.class
    klass.superclass == ActiveRecord::Base ? klass.to_s : klass.superclass.to_s
  end

  def self.non_decorated_class_name(obj)
    class_or_superclass(obj.class.name["Decorator"] ? obj.model.class : obj.class)
  end
end