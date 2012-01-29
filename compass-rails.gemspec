# -*- encoding: utf-8 -*-
require File.expand_path('../lib/compass-rails/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Scott Davis"]
  gem.email         = ["jetviper21@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "compass-rails"
  gem.require_paths = ["lib"]
  gem.version       = Compass::Rails::VERSION

  gem.add_dependency 'rails'
  gem.add_dependency 'compass', '~> 0.12.alpha'

end
