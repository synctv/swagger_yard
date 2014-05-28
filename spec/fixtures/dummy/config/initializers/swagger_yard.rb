SwaggerYard.configure do |config|
  config.reload = true
  config.swagger_version = "1.1"
  config.api_version = "1.0"
  config.doc_base_path = "http://localhost:3000/doc"
  config.api_base_path = "http://localhost:3000/api"
  config.doc_base_path = "http://localhost:3000/swagger/api"
  config.api_base_path = "http://localhost:3000/swagger/api"
end
