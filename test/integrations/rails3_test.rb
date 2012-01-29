require 'test_helper'
class Rails3Test < Test::Unit::TestCase
  include CompassRails::Test::RailsHelpers
  RAILS_VERSION = RAILS_3

  def test_rails_app_created
    within_rails_app('test_railtie', RAILS_VERSION) do |project|
      assert project.boots?
    end
  end

  def test_installs_compass
    within_rails_app('test_railtie', RAILS_VERSION) do |project|
      project.run_compass('init')
      assert project.has_config?
      assert project.has_screen_file?
      assert project.has_compass_import?
    end
  end

  def test_compass_compile
    within_rails_app('test_railtie', RAILS_VERSION) do |project|
      project.run_compass('init')
      project.run_compass('compile')
      assert project.directory.join('public/stylesheets/screen.css').exist?
    end
  end

  def test_install_blueprint
    within_rails_app('test_railtie', RAILS_VERSION) do |project|
      project.run_compass('init')
      project.run_compass('install blueprint --force')
      assert project.directory.join('app/assets/stylesheets/partials').directory?
    end
  end

end