require 'test/unit'
require 'compass-rails'
require 'rainbow'

module CompassRails
  module Test
    ROOT_PATH = File.expand_path('../../', __FILE__)
  end
end

%w(debug file command rails).each do |helper|
  require File.join(File.expand_path('../', __FILE__), 'helpers', "#{helper}_helper")
end

require File.join(File.expand_path('../', __FILE__), 'helpers', "rails_project")