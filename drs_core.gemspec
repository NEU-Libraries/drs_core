$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "drs_core/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "drs_core"
  s.version     = DrsCore::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of DrsCore."
  s.description = "TODO: Description of DrsCore."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.13"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
end
