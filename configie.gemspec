# -*- encoding: utf-8 -*-

require File.expand_path('../lib/configie/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "configie"
  gem.version       = Configie::VERSION
  gem.summary       = %q{Configie can help you config your application in one place with the power of blocks.}
  gem.description   = %q{Configie allows you to create your config variable for your application with blocks. With the help of Ruby blocks, you can define your configs easier than ever before.}
  gem.license       = "MIT"
  gem.authors       = ["Ranmocy Sheng"]
  gem.email         = "ranmocy@gmail.com"
  gem.homepage      = "https://rubygems.org/gems/configie"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'guard-rspec', '~> 4.5'
  gem.add_development_dependency 'rake', '~> 0.8'
  gem.add_development_dependency 'rdoc', '~> 3.0'
  gem.add_development_dependency 'rspec', '~> 2.4'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
end
