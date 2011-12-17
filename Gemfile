source 'https://rubygems.org'

# Specify your gem's dependencies in compass-rails.gemspec
gemspec

gem 'compass', '~> 0.12.alpha'

group :test do
  gem 'mocha'
  gem "appraisal", :git => 'git://github.com/scottdavis/appraisal.git'
  gem 'rainbow'
end

unless ENV["CI"]
  gem 'rb-fsevent', :require => false
  gem 'ruby_gntp', :require => false
  gem 'guard'
  gem 'guard-test'
end