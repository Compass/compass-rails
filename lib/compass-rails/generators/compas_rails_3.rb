require "compass"

class CompassGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("../templates", __FILE__)

  def init_compass
    data = Compass::Configuration::Data.new("rails_config")
    data.project_type = :rails
    Compass.add_configuration(data)
  end
   
  def copy_config_file
    create_file "config/compass.rb", Compass.configuration.serialize
  end

  def create_asset_paths
    empty_directory Compass.configuration.sass_dir
    if Rails.version =~ /3.0/
      create_file "#{Compass.configuration.sass_dir}/application.scss" do
        <<-SCSS
        @import "compass";
        SCSS
      end
  end

end