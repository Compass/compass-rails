require 'compass'
require "compass-rails/version"
require "compass-rails/configuration"

module CompassRails

    RAILS_32 = %r{^3.2}
    RAILS_31 = %r{^3.1}
    RAILS_23 = %r{^2.3}
    RAILS_3 = %r{^3.0}

    extend self

    def load_rails
      return if defined?(::Rails) && !::Rails.application.nil?
      rails_config_path = Dir.pwd
      until File.exists?(File.join(rails_config_path, 'config', 'application.rb')) do
        raise 'Rails application not found' if rails_config_path == '/'
        rails_config_path = File.join(rails_config_path, '..')
      end
      #load the rails config
      require "#{rails_config_path}/config/application.rb"
      require 'sass-rails' unless rails3?
    end

    def context
      require "sprockets/helpers/rails_helper"
      klass = ::Sprockets::Environment.new(root.to_s).context_class
      klass.extend(::Sprockets::Helpers::IsolatedHelper)
      klass.extend(::Sprockets::Helpers::RailsHelper)
      klass
    end

    def installer(*args)
      CompassRails::Installer.new(*args)
    end

    def rails_loaded?
      defined?(::Rails)
    end

    def rails_version
      Gem.loaded_specs["rails"].version.to_s
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
      if (rails31? || rails32?)
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
        Compass::Util.compass_warn("Warning: Compass was booted twice. Compass has a Railtie now; please remove your initializer.")
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
      app.config.compass.to_sass_engine_options.each do |key, value|
        app.config.sass.send(:"#{key}=", value)
      end
    end

    def boot_config
      config = Compass::Configuration::Data.new("compass_rails_boot")
      config.project_type = :rails

      config
    end

  def asset_pipeline_enabled?
    return false unless rails_loaded?
    rails_config = ::Rails.application.config
    rails_config.respond_to?(:assets) && rails_config.assets.try(:enabled)
  end

end

Compass::AppIntegration.register(:rails, "::CompassRails")
Compass.add_configuration(CompassRails.boot_config)


require "compass-rails/railties"
require "compass-rails/installer"


