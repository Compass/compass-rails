require 'compass'
require "compass-rails/version"
require "compass-rails/configuration"

module CompassRails

    RAILS_4 = %r{^4.0}
    RAILS_32 = %r{^3.2}
    RAILS_31 = %r{^3.1}
    RAILS_23 = %r{^2.3}
    RAILS_3 = %r{^3.0}

    extend self

    def load_rails
      return if defined?(::Rails) && ::Rails.respond_to?(:application) && !::Rails.application.nil?

      rails_config_path = Dir.pwd
      until File.exists?(File.join(rails_config_path, 'config', 'application.rb')) do
        raise 'Rails application not found' if rails_config_path == '/'
        rails_config_path = File.join(rails_config_path, '..')
      end
      #load the rails config
      require "#{rails_config_path}/config/application.rb"
      if rails31? || rails32? || rails4?
        require 'sass-rails'
        if rails4?
          require 'sprockets-rails'
        else
          require 'sprockets/railtie'
        end
        require 'rails/engine'
        @app ||= ::Rails.application.initialize!(:assets)
      end
    end


    def setup_fake_rails_env_paths(sprockets_env)
      return unless rails_loaded?
      keys = ['app/assets', 'lib/assets', 'vendor/assets']
      local = keys.map {|path| ::Rails.root.join(path) }.map { |path| [File.join(path, 'images'), File.join(path, 'stylesheets')] }.flatten!
      sprockets_env.send(:trail).paths.unshift(*local)
      paths = []
      ::Rails::Engine.subclasses.each do |subclass|
        paths = subclass.paths
        keys.each do |key|
          sprockets_env.send(:trail).paths.unshift(*paths[key].existent_directories)
        end
      end
    end

    def sass_config
      load_rails
      ::Rails.application.config.sass
    end

    def sprockets
      load_rails
      @sprockets ||= ::Rails.application.assets
    end

    def context
      load_rails
      @context ||= begin
        sprockets.version = ::Rails.env + "-#{sprockets.version}"
        setup_fake_rails_env_paths(sprockets)
        context = ::Rails.application.assets.context_class
        context.extend(::Sprockets::Helpers::IsolatedHelper)
        context.extend(::Sprockets::Helpers::RailsHelper)
        context.extend(::Sass::Rails::Railtie::SassContext)
        context.sass_config = sass_config

        context
      end
    end

    def installer(*args)
      CompassRails::Installer.new(*args)
    end

    def rails_loaded?
      defined?(::Rails)
    end

    def rails_version
      rails_spec = (Gem.loaded_specs["railties"] || Gem.loaded_specs["rails"])
      raise "You have to require Rails before compass" unless rails_spec
      rails_spec.version.to_s
    end

    def rails3?
      return false unless defined?(::Rails)
      rails_version =~ RAILS_3
    end

    def rails31?
      return false unless defined?(::Rails)
      rails_version =~ RAILS_31
    end

    def rails32?
      return false unless defined?(::Rails)
      rails_version =~ RAILS_32
    end

    def rails4?
      return false unless defined?(::Rails)
      rails_version =~ RAILS_4
    end

    def rails2?
      rails_version =~ RAILS_23
    end

    def booted!
      CompassRails.const_set(:BOOTED, true)
    end

    def booted?
      defined?(CompassRails::BOOTED) && CompassRails::BOOTED
    end

    def configuration
      load_rails unless rails2?
      config = Compass::Configuration::Data.new('rails')
      config.extend(Configuration::Default)
      if (rails31? || rails32? || rails4?)
        if asset_pipeline_enabled?
          require "compass-rails/configuration/3_1"
          config.extend(Configuration::Rails3_1)
        end
      end
      config
    end

    def env
      env_production? ? :production : :development
    end

    def prefix
      ::Rails.application.config.assets.prefix
    end

    def env_production?
      if defined?(::Rails) && ::Rails.respond_to?(:env)
        ::Rails.env.production?
      elsif defined?(RAILS_ENV)
        RAILS_ENV == "production"
      end
    end

    def root
      @root ||= begin
        if defined?(::Rails) && ::Rails.respond_to?(:root)
          ::Rails.root
        elsif defined?(RAILS_ROOT)
          Pathname.new(RAILS_ROOT)
        else
          Pathname.new(Dir.pwd)
        end
      end
    end

    def check_for_double_boot!
      if booted?
        Compass::Util.compass_warn("Warning: Compass was booted twice. Compass-rails has got your back; please remove your compass initializer.")
      else
        booted!
      end
    end

    def sass_plugin_enabled?
      unless rails31?
        defined?(Sass::Plugin) && !Sass::Plugin.options[:never_update]
      end
    end

    # Rails 2.x projects use this in their compass initializer.
    def initialize!(config = nil)
      check_for_double_boot!
      config ||= Compass.detect_configuration_file(root)
      Compass.add_project_configuration(config, :project_type => :rails)
      Compass.discover_extensions!
      Compass.configure_sass_plugin!
      Compass.handle_configuration_change! if sass_plugin_enabled?
    end

    def configure_rails!(app)
      return unless app.config.respond_to?(:sass)
      sass_config = app.config.sass
      compass_config = app.config.compass

      sass_config.load_paths.concat(compass_config.sass_load_paths)

      { :output_style => :style,
        :line_comments => :line_comments,
        :cache => :cache,
        :disable_warnings => :quiet,
        :preferred_syntax => :preferred_syntax
      }.each do |compass_option, sass_option|
        set_maybe sass_config, compass_config, sass_option, compass_option
      end
      if compass_config.sass_options
        compass_config.sass_options.each do |config, value|
          sass_config.send("#{config}=", value)
        end
      end
    end

    def boot_config
      config = if (config_file = Compass.detect_configuration_file) && (config_data = Compass.configuration_for(config_file))
        config_data
      else
        Compass::Configuration::Data.new("compass_rails_boot")
      end
      config.top_level.project_type = :rails
      config
    end

  def asset_pipeline_enabled?
    return false unless rails_loaded?
    rails_config = ::Rails.application.config
    rails_config.respond_to?(:assets) && rails_config.assets.try(:enabled)
  end

  private

    # sets the sass config value only if the corresponding compass-based setting
    # has been explicitly set by the user.
    def set_maybe(sass_config, compass_config, sass_option, compass_option)
      if compass_value = compass_config.send(:"#{compass_option}_without_default")
        sass_config.send(:"#{sass_option}=", compass_value)
      end
    end

end

Compass::AppIntegration.register(:rails, "::CompassRails")
Compass.add_configuration(CompassRails.boot_config)

require "compass-rails/patches"
require "compass-rails/railties"
require "compass-rails/installer"


