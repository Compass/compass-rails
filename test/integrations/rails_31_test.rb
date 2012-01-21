require 'test_helper'
class Rails31Test < Test::Unit::TestCase
  include CompassRails::Test::RailsHelpers

  def test_rails_app_created
    within_rails_app('test_railtie', RAILS_3_1) do |project|
      project.install_compass
      assert project.has_gem? 'compass'
      project.bundle
      assert project.rails3?
      assert project.boots?
      assert project.has_generator?('compass_rails')
    end
  end

  def test_generator_installs_compass
  within_rails_app('test_railtie', RAILS_3_1) do |project|
    project.install_compass
    project.bundle
    project.generate('compass_rails:install')
    assert project.has_screen_file?
    assert project.has_compass_import?
  end
end

end