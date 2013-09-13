require 'rails/generators'

module SwaggerYard
  class JsGenerator < Rails::Generators::Base
    source_root File.expand_path("../../../../public/swagger-ui", __FILE__)
    desc "Add swagger-ui js to /public for customization"
    
    def generate_layout  
      copy_file "swagger-ui_org.js", "public/swagger-ui/swagger-ui.js"
      directory "lib", "public/swagger-ui/lib"
    end
  end
end