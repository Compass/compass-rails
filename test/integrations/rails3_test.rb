require 'test_helper'
class Rails3Test < Test::Unit::TestCase
  include CompassRails::Test::RailsHelpers

  def test_rails_app_created
    within_rails_app('test_railtie', RAILS_3) do |project|
      project.install_compass
      assert project.has_gem? 'compass'
      assert project.rails3?
      assert project.boots?
    end
  end

  def test_generator_installs_compass
    within_rails_app('test_railtie', RAILS_3) do |project|
      project.install_compass
      project.bundle!
      project.generate('compass_rails:install')
      assert project.has_screen_file?
      assert project.has_compass_import?
    end
  end

  def test_compass_compile
    within_rails_app('test_railtie', RAILS_3) do |project|
      project.install_compass
      project.bundle!
      project.generate('compass_rails:install')
      project.run_compass('compile')
      assert project.directory.join('public/stylesheets/screen.css').exist?
    end
  end


end