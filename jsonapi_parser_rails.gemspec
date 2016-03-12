$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "json/api/rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "jsonapi_parser_rails"
  s.version     = JSON::API::Rails::VERSION
  s.authors     = ["Lucas Hosseini"]
  s.email       = ["lucas.hosseini@gmail.com"]
  s.homepage    = "https://github.com/beauby/jsonapi_parser_rails"
  s.summary     = "TODO: Summary of JsonapiParserRails."
  s.description = "TODO: Description of JsonapiParserRails."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5.2"
  s.add_dependency "jsonapi_parser", "~> 0.2"

  s.add_development_dependency "sqlite3"
end
