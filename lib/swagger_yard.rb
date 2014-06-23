require "yard"
require "json"
require "swagger_yard/configuration"
require "swagger_yard/engine"
require "swagger_yard/cache"
require "swagger_yard/parser"
require "swagger_yard/model"

module SwaggerYard
  class << self
    ##
    # Configuration for Swagger Yard, use like:
    #
    #   SwaggerYard.configure do |config|
    #     config.swagger_version = "1.1"
    #     config.api_version = "0.1"
    #     config.doc_base_path = "http://swagger.example.com/doc"
    #     config.api_base_path = "http://swagger.example.com/api"
    #   end
    def configure
      @configuration ||= Configuration.new
      yield @configuration
    end

    def config
      @configuration
    end

    def resource_to_file_path
      @resource_to_file_path ||= {}
    end

    #
    # Use YARD to parse object tags from a file
    # 
    # @param file_path [string] The complete path to file
    # @return [YARD] objects representing class/methods and tags from the file
    # 
    def yard_objects_from_file(file_path)
      ::YARD::Registry.clear
      ::YARD.parse(file_path)
      ::YARD::Registry.all
    end

    def parse_file(file_path)
      @parser.run(yard_objects_from_file(file_path))
    end

    def generate!(controller_path, model_path = nil)
      register_custom_yard_tags!

      @model_path = model_path
      @controller_path = controller_path

      get_listing
    end

    def get_api(resource_name)
      if config.reload
        parse_file(resource_to_file_path[resource_name]).to_h
      else
        cache.fetch(resource_name) { parse_file(resource_to_file_path[resource_name]).to_h }
      end
    end

    def models
      if config.reload
        parse_models
      else
        cache.fetch("models") { parse_models }
      end
    end

    def get_listing
      if config.reload
        parse_controllers
      else
        cache.fetch("listing_index") { parse_controllers }
      end
    end

  private
    ##
    # Register some custom yard tags used by swagger-ui
    def register_custom_yard_tags!
      ::YARD::Tags::Library.define_tag("Api resource", :resource)
      ::YARD::Tags::Library.define_tag("Resource path", :resource_path)
      ::YARD::Tags::Library.define_tag("Api path", :path)
      ::YARD::Tags::Library.define_tag("Parameter", :parameter)
      ::YARD::Tags::Library.define_tag("Parameter list", :parameter_list)
      ::YARD::Tags::Library.define_tag("Status code", :status_code)
      ::YARD::Tags::Library.define_tag("Implementation notes", :notes)
      ::YARD::Tags::Library.define_tag("Response class", :response_class)
      ::YARD::Tags::Library.define_tag("Api Summary", :summary)
      ::YARD::Tags::Library.define_tag("Model resource", :model)
      ::YARD::Tags::Library.define_tag("Model property", :property, :with_types_and_name)
    end

    def cache
      @cache ||= Cache.new(config.cache_store, config.cache_prefix)
    end

    def parse_models
      return [] unless @model_path

      Dir[@model_path].map do |file_path|
        Model.from_yard_objects(yard_objects_from_file(file_path))
      end
    end

    def parse_controllers
      @parser = Parser.new

      Dir[@controller_path].each do |file|
        if api_declaration = parse_file(file)
          resource_to_file_path[api_declaration.resource_name] = file
          cache[api_declaration.resource_name] = api_declaration.to_h
        end
      end

      @parser.listing.to_h
    end
  end
end
