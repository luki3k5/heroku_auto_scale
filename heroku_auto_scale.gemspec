# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'heroku_auto_scale/version'

Gem::Specification.new do |spec|
  spec.name          = "heroku_auto_scale"
  spec.version       = HerokuAutoScale::VERSION
  spec.authors       = ["luki3k5"]
  spec.email         = ["luki3k5@gmail.com"]
  spec.summary       = %q{Simple DSL for creating scaling rules for worker dynos on Heroku}
  spec.description   = %q{Simple DSL for creating scaling rules for worker dynos on Heroku}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'platform-api'
  spec.add_dependency 'redis'
  spec.add_dependency 'sidekiq'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "rspec-collection_matchers"
  spec.add_development_dependency "webmock"

  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "pry"
end
