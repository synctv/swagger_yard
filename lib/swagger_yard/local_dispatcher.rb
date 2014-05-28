module SwaggerYard
  # An instance of LocalEnvironment is responsible for determining the dispatcher. 
  # This is useful to determine whether or not to run SwaggerYard#generate!.
  # 
  # Implementation heavily borrowed from NewRelic.
  class LocalDispatcher
    def discovered_dispatcher
      discover_dispatcher unless @discovered_dispatcher
      @discovered_dispatcher
    end

    def server?
      [:thin, :unicorn, :puma].include?(discovered_dispatcher)
    end

  private

    def discover_dispatcher
      dispatchers = %w[sidekiq thin unicorn puma]
      while dispatchers.any? && @discovered_dispatcher.nil?
        send 'check_for_' + (dispatchers.shift)
      end
    end

    def find_class_in_object_space(klass)
      ObjectSpace.each_object(klass) do |x|
        return x
      end
      return nil
    end

    def check_for_unicorn
      if defined?(::Unicorn) && defined?(::Unicorn::HttpServer)
        v = find_class_in_object_space(::Unicorn::HttpServer)
        @discovered_dispatcher = :unicorn if v
      end
    end

    def check_for_sidekiq
      if defined?(::Sidekiq) && File.basename($0) == 'sidekiq'
        @discovered_dispatcher = :sidekiq
      end
    end

    def check_for_thin
      if defined?(::Thin) && defined?(::Thin::VERSION)
        @discovered_dispatcher = :thin
      end
    end

    def check_for_puma
      if defined?(::Puma) && defined?(::Puma::Const::VERSION)
        @discovered_dispatcher = :puma
      end
    end
  end
end