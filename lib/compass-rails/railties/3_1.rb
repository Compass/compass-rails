#3.1.3
require 'compass'
require 'rails/railtie'

class Rails::Railtie::Configuration
  # Adds compass configuration accessor to the application configuration.
  #
  # If a configuration file for compass exists, it will be read in and
  # the project's configuration values will already be set on the config
  # object.
  #
  # For example:
  #
  #     module MyApp
  #       class Application < Rails::Application
  #          config.compass.line_comments = !Rails.env.production?
  #          config.compass.fonts_dir = "app/assets/fonts"
  #       end
  #     end
  #
  # It is suggested that you create a compass configuration file if you
  # want a quicker boot time when using the compass command line tool.
  #
  # For more information on available configuration options see:
  # http://compass-style.org/help/tutorials/configuration-reference/
  def compass
    @compass ||= begin
      data = if (config_file = Compass.detect_configuration_file) && (config_data = Compass.configuration_for(config_file))
        config_data
      else
        Compass::Configuration::Data.new("rails_config")
      end
      data.project_type = :rails # Forcing this makes sure all the rails defaults will be loaded.
      Compass.add_configuration(:rails)
      Compass.add_configuration(data)
      Compass.configuration.on_sprite_saved do |filename|
        # This is a huge hack based on reading through the sprockets internals.
        # Sprockets needs an API for adding assets during precompilation.
        # At a minimum sprockets should provide this API:
        #
        #     #filename is a path in the asset source directory
        #     Rails.application.assets.new_asset!(filename)
        #
        #     # logical_path is how devs refer to it, data is the contents of it.
        #     Rails.application.assets.new_asset!(logical_path, data)
        #
        # I would also like to select one of the above calls based on whether
        # the user is precompiling or not:
        #
        #     Rails.application.assets.precompiling? #=> true or false
        #
        # But even the above is not an ideal API. The issue is that compass sprites need to
        # avoid generation if the sprite file is already generated (which can be quite time
        # consuming). To do this, compass has it's own uniqueness hash based on the user's
        # inputs instead of being based on the file contents. So if we could provide our own
        # hash or some metadata that is opaque to sprockets that could be read from the
        # asset's attributes, we could avoid cluttering the assets directory with generated
        # sprites and always just use the logical_path + data version of the api.
        if Rails.application.config.assets.digest && # if digesting is enabled
            caller.grep(/static_compiler/).any? && #OMG HAX - check if we're being precompiled
            Compass.configuration.generated_images_path[Compass.configuration.images_path] # if the generated images path is not in the assets images directory, we don't have to do these backflips

          # Clear entries in Hike::Index for this sprite's directory.
          # This makes sure the asset can be found by find_assets
          Rails.application.assets.send(:trail).instance_variable_get(:@entries).delete(File.dirname(filename))

          pathname      = Pathname.new(filename)
          logical_path  = pathname.relative_path_from(Pathname.new(Compass.configuration.images_path))
          asset         = Rails.application.assets.find_asset(logical_path)
          target        = File.join(Rails.public_path, Rails.application.config.assets.prefix, asset.digest_path)

          # Adds the asset to the manifest file.
          Sprockets::StaticCompiler.generated_sprites[logical_path.to_s] = asset.digest_path

          # Adds the fingerprinted asset to the public directory
          FileUtils.mkdir_p File.dirname(target)
          asset.write_to target

        end
      end
      data
    end
    @compass
  end
end

module CompassRails
  class Railtie < Rails::Railtie

    initializer "compass.initialize_rails", :group => :all do |app|
      require 'compass-rails/patches/3_1'
      # Configure compass for use within rails, and provide the project configuration
      # that came via the rails boot process.
      CompassRails.check_for_double_boot!
      Compass.discover_extensions!
      CompassRails.configure_rails!(app)
    end
  end
end
