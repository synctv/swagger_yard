module SwaggerYard
  class ApiDeclaration
    attr_accessor :description, :resource_path

    def initialize
      @apis   = {}
      @models = []
    end

    def add_listing_info(yard_object)
      @description = yard_object.docstring if yard_object.docstring.present?
      tag = yard_object.tags.find { |tag| tag.tag_name == "resource_path"}
      @resource_path = tag.text.downcase if tag.present?
      tag.present?
    end

    def add_api(api)
      if @apis.keys.include?(api.path)
        same_api_path = @apis[api.path]
        same_api_path["operations"] << api.operation
        @apis[api.path] = same_api_path
      else
        @apis[api.path] = api.to_h
      end 
    end

    def resource_name
      @resource_path
    end

    def to_h
      { 
        "apiVersion"     => SwaggerYard.api_version,
        "swaggerVersion" => SwaggerYard.swagger_version,
        "basePath"       => SwaggerYard.api_base_path,
        "resource_path"  => @resource_path,
        "apis"           => @apis.values,
        "models"         => @models
      }
    end
  end
end