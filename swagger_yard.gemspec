$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "swagger_yard/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "swagger_yard"
  s.version     = SwaggerYard::VERSION
  s.authors     = ["chtrinh (Chris Trinh)"]
  s.email       = ["chris@synctv.com"]
  s.homepage    = "http://www.synctv.com"
  s.summary     = %q{SwaggerYard API doc through YARD}
  s.description = %q{SwaggerYard API doc gem that uses YARD to parse the docs for a REST rails API}

  s.files = Dir["{app,config,public,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.8"
  s.add_development_dependency "sqlite3"
  s.add_runtime_dependency 'yard'
end
