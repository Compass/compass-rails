require 'test_helper'
class Rails23Test < Test::Unit::TestCase
  include CompassRails::Test::RailsHelpers

  def test_rails_app_created
    within_rails_app('test_railtie', RAILS_2) do |project|
      project.install_compass
      project.has_gem?('compass')
      project.boots?
      assert project.rails2?
    end
  end
end