require 'test_helper'
class Rails3Test < Test::Unit::TestCase
  include CompassRails::Test::RailsHelpers

  def test_rails_app_crated
    within_rails_app('test_railtie', RAILS_3) do |project|
      project.install_compass
      assert project.has_gem? 'compass'
      assert project.has_file?(File.join('config', 'application.rb'))
    end
  end


end