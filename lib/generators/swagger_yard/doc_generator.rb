require 'rails/generators'
module SwaggerYard
  class DocGenerator < Rails::Generators::Base
    source_root File.expand_path("../../../../app/views/swagger_yard/swagger", __FILE__)
    desc "Add swagger-ui doc ERB file to app/views for customization"
    
    def generate_layout  
      copy_file "doc.html.erb", "app/views/swagger_yard/swagger/doc.html.erb"
    end
  end
end