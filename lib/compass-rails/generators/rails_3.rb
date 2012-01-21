require "compass"
module CompassRails
  module Generators
    class InstallGenerator < Base
      desc "Installs compass"
      source_root File.expand_path("../templates", __FILE__)

      def init_compass
        Compass.add_configuration(CompassRails.configuration)
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

        if File.exist?(file = File.join(Compass.configuration.sass_dir, "screen.scss"))
          append_file file, compass_imports
        else
          create_file file, compass_imports
        end
      end

    end
  end
end