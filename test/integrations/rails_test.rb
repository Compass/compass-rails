require 'test_helper'

class RailsTest < Test::Unit::TestCase
  include CompassRails::Test::RailsHelpers

  RAILS_VERSION = VERSION_LOOKUP.detect { |version, regex| CompassRails.version_match(regex) }.first

  def test_rails_app_created
    within_rails_app('test_railtie', RAILS_VERSION) do |project|
      assert project.boots?
    end
  end

  def test_sass_preferred_syntax
    within_rails_app('test_railtie', RAILS_VERSION) do |project|
      assert_equal "scss", project.rails_property("sass.preferred_syntax")
      project.set_rails('sass.preferred_syntax', :sass)
      assert_equal "sass", project.rails_property("sass.preferred_syntax")
    end
  end

  def test_compass_css_dir
    within_rails_app('test_railtie', RAILS_VERSION) do |project|
      assert_equal "public/assets", project.rails_property("compass.css_dir")
      project.set_rails('compass.css_dir', "public/stylesheets")
      assert_equal "public/stylesheets", project.rails_property("compass.css_dir")
    end
  end
end
