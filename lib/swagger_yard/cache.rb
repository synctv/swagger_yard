module SwaggerYard
  # For now just a simple wrapper class for a Memcache client.
  class Cache

    attr_reader :prefix, :store

    def initialize(store, prefix)
      @store = store
      @prefix = prefix
    end

    # Read from the Cache.
    def [](resource_name)
      case
        when store.respond_to?(:read)
          store.read key_for(resource_name)
        when store.respond_to?(:[])
          store[key_for(resource_name)]
        when store.respond_to?(:get)
          store.get key_for(resource_name)
      end
    end

    # Write to the Cache.
    def []=(resource_name, value)
      case
        when store.respond_to?(:write)
          store.write key_for(resource_name), value
        when store.respond_to?(:[]=)
          store[key_for(resource_name)] = value
        when store.respond_to?(:set)
          store.set key_for(resource_name), value
      end
    end

    def fetch(resource_name)
      value = self[resource_name]
      if value.nil? && block_given?
        value = yield
        self[resource_name] = yield
      end
      value
    end

    # Cache key for a given entry.
    def key_for(resource_name)
      [prefix, resource_name].join
    end
  end
end