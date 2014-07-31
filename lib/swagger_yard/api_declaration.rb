module SwaggerYard
  class ApiDeclaration
    attr_accessor :description, :resource_path
    attr_reader :apis

    def initialize(resource_listing)
      @resource_listing = resource_listing

      @apis   = {}
    end

    def valid?
      !@resource_path.nil?
    end

    def add_yard_objects(yard_objects)
      yard_objects.each do |yard_object|
        add_yard_object(yard_object)
      end
      self
    end

    def add_yard_object(yard_object)
      case yard_object.type
      when :class
        add_listing_info(ListingInfo.new(yard_object))
      when :method
        add_api(yard_object)
      end
    end

    def add_listing_info(listing_info)
      @description = listing_info.description
      @resource_path = listing_info.resource_path
    end

    def add_api(yard_object)
      path = Api.path_from_yard_object(yard_object)

      return if path.nil?

      api = (apis[path] ||= Api.from_yard_object(yard_object, self))
      api.add_operation(yard_object)
    end

    def resource_name
      @resource_path
    end

    def models
      model_names = model_names_from_apis
      @resource_listing.models.select {|m| model_names.include?(m.id)}
    end

    def ref?(name)
      @resource_listing.models.map(&:id).include?(name)
    end

    def to_h
      { 
        "apiVersion"     => SwaggerYard.config.api_version,
        "swaggerVersion" => SwaggerYard.config.swagger_version,
        "basePath"       => SwaggerYard.config.api_base_path,
        "resourcePath"   => resource_path,
        "apis"           => apis.values.map(&:to_h),
        "models"         => Hash[models.map {|m| [m.id, m.to_h]}]
      }
    end

    def listing_hash
      {
        "path"        => resource_path,
        "description" => description
      }
    end

    private
    def model_names_from_apis
      apis.values.map(&:model_names).flatten.uniq
    end
  end
end
