module SwaggerYard
  class ApiDeclaration
    attr_accessor :description, :resource_path

    def initialize
      @apis   = {}
      @model_names = []
    end

    def valid?
      !@resource_path.nil?
    end

    def add_listing_info(listing_info)
      @description = listing_info.description
      @resource_path = listing_info.resource_path
    end

    def add_api(api)
      return unless api.valid?

      @model_names += api.model_names

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

    attr_reader :resource_path, :apis

    def models
      SwaggerYard.models.select {|m| @model_names.include?(m.id)}
    end

    def to_h
      { 
        "apiVersion"     => SwaggerYard.config.api_version,
        "swaggerVersion" => SwaggerYard.config.swagger_version,
        "basePath"       => SwaggerYard.config.api_base_path,
        "resourcePath"   => resource_path,
        "apis"           => apis.values,
        "models"         => models.map(&:to_h)
      }
    end
  end
end