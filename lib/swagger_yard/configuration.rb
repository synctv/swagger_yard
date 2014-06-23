module SwaggerYard
  class Configuration
    attr_accessor :doc_base_path, :api_base_path, :api_path
    attr_accessor :swagger_version, :api_version
    attr_accessor :cache_store, :cache_prefix
    attr_accessor :enable, :reload

    def initialize
      self.swagger_version = "1.1"
      self.api_version = "0.1"
      # do we automatically need to require Rails?
      # do we even need caching on this?
      self.cache_store = Rails.cache
      self.cache_prefix = "swagger_yard/"
      self.enable = false
      self.reload = true
    end
  end
end