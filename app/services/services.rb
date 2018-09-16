class Services
  class << self
    def concerns klass
      define_singleton_method(:model_class) { klass }
    end

    def create parent, user, object_params
      child = parent.send(collection_name).build

      # Convert object to proper class for validations and callbacks
      # Do this before loading other attributes as not all relationships are properly copied with becomes
      if object_params && object_params[:type] && child.respond_to?(:type)
        child = child.becomes(object_params[:type].constantize)
      end

      child.update_attributes(object_params)
      child
    end

    def update object, user, object_params
      object.update_attributes(object_params)
    end

    private

    def instance_name
      model_class.to_s.underscore
    end

    def collection_name
      instance_name.pluralize
    end
  end
end
