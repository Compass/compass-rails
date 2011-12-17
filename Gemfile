source 'https://rubygems.org'

# Specify your gem's dependencies in compass-rails.gemspec
gemspec

gem 'compass', :path => '../compass'

group :test do
  gem 'mocha'
  gem "appraisal", :git => 'git://github.com/scottdavis/appraisal.git'
  gem 'rainbow'
end

unless ENV["CI"]
  gem 'rb-fsevent'
  gem 'ruby_gntp'
  gem 'guard'
  gem 'guard-test'
end