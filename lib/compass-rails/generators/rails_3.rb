require "compass"
module CompassRails
  module Generators
    class InstallGenerator < Base
      desc "Installs compass"
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

        compass_imports = <<-SCSS
@import "compass";
@import "compass/reset";
        SCSS

        if CompassRails.rails3?
          create_file File.join(Compass.configuration.sass_dir, "screen.scss"), compass_imports
        elsif CompassRails.rails31?
          append_file File.join(Compass.configuration.sass_dir, "screen.scss"), compass_imports
        end
      end

    end
  end
end