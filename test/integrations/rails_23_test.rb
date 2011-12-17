require 'test_helper'
class Rails23Test < Test::Unit::TestCase
  include CompassRails::Test::RailsHelpers

  def test_rails_app_crated
    within_rails_app('test_railtie', RAILS_2) do |project|
      project.install_compass
      project.has_gem?('compass')
      assert File.exists?(File.join(WORKING_DIR, project.directory_name, 'config', 'boot.rb'))
      assert !File.exists?(File.join(WORKING_DIR, project.directory_name, 'config', 'applicaton.rb'))
    end
  end
end