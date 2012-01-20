require 'test_helper'
class Rails33Test < Test::Unit::TestCase
  include CompassRails::Test::RailsHelpers

  def test_rails_app_created
    within_rails_app('test_railtie', RAILS_3_2) do |project|
      project.install_compass
      assert project.has_gem? 'compass'
      project.bundle
      assert project.rails3?
      assert project.has_generator?('compas')
    end
  end

end