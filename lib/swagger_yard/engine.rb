module SwaggerYard
  class Engine < ::Rails::Engine
    isolate_namespace SwaggerYard

    initializer 'swagger_yard.load_static_assets' do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end

    initializer "swagger_yard.finisher_hook" do |app|
      SwaggerYard.generate!("#{app.root}/app/controllers/**/*.rb")
    end
  end
end
