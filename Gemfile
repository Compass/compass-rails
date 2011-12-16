source 'https://rubygems.org'

# Specify your gem's dependencies in compass-rails.gemspec
gemspec

group :test do
  gem 'mocha'
  gem "appraisal"
end

unless ENV["CI"]
  gem 'rb-fsevent'
  gem 'growl_notify'
  gem 'guard'
  gem 'guard-test'
end