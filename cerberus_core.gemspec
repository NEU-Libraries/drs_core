$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cerberus_core/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cerberus_core"
  s.version     = CerberusCore::VERSION
  s.authors     = ["Will Jackson"]
  s.email       = ["wjackson64@gmail.com"]
  s.homepage    = "http://github.com/NEU-Libraries/"
  s.summary     = "Core architectural components of a fedora repository built in the DRS repository."
  s.description = "What it says on the tin"

  s.required_ruby_version = "~> 2.0.0"

  s.add_runtime_dependency "jettywrapper", "= 1.4.1"

  s.add_dependency "rails", "~> 4.0.0"
  s.add_dependency "hydra-head", "7.2.0"
  s.add_dependency "hydra-derivatives", "0.0.8"
  s.add_dependency "curb"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-its"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]
end
