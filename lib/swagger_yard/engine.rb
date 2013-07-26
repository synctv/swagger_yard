require "swagger_yard/local_dispatcher"

module SwaggerYard
  class Engine < ::Rails::Engine
    if SwaggerYard::LocalDispatcher.new.server?
      isolate_namespace SwaggerYard

      # NOTE: We should opt for asset pipeline instead of this.
      initializer 'swagger_yard.load_static_assets' do |app|
        app.middleware.use(::ActionDispatch::Static, "#{root}/public")
      end

      initializer "swagger_yard.finisher_hook" do |app|
        SwaggerYard.generate!("#{app.root}/app/controllers/**/*.rb")
      end
    end
  end
end
