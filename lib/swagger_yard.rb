require "yard"
require "json"
require "swagger_yard/engine"
require "swagger_yard/cache"
require "swagger_yard/parser"

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
      yield self
    end

    attr_accessor :doc_base_path, :api_base_path, :api_path
    attr_writer :swagger_version, :api_version, :cache_store, :cache_prefix, :enable, :reload

    def cache_store
      @cache_store ||= Rails.cache
    end
    
    def cache_prefix
      @cache_prefix ||= "swagger_yard/"
    end

    def swagger_version
      @swagger_version ||= "1.1"
    end

    def api_version
      @api_version ||= "0.1"
    end

    def enable
      @enable ||= false
    end

    def reload
      @reload ||= false
    end

    def resource_to_file_path
      @resource_to_file_path ||= {}
    end

    def parse_file(file_path)
      ::YARD.parse(file_path)
      yard_objects = ::YARD::Registry.all
      ::YARD::Registry.clear
      @parser.run(yard_objects)
    end

    def generate!(controller_path)
      register_custom_yard_tags!
      @controller_path = controller_path
      cache.fetch("listing_index") { parse_controllers }
    end

    def get_api(resource_name)
      if reload
        parse_file(resource_to_file_path[resource_name]).to_h
      else
        cache.fetch(resource_name) { parse_file(resource_to_file_path[resource_name]).to_h }
      end
    end

    def get_listing
      if reload
        parse_controllers
      else
        cache.fetch("listing_index") { parse_controllers }
      end
    end

    def clear_cache
      cache["listing_index"] = nil
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
    end

    def cache
      @cache ||= Cache.new(cache_store, cache_prefix)
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
