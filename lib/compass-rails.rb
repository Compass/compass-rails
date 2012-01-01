require 'compass'
require "compass-rails/version"
require "compass-rails/configuration"

module CompassRails

    RAILS_31 = %r{3.1}
    RAILS_23 = %r{2.3}
    RAILS_3 = %r{3.0}

    extend self

    def rails3?
      ::Rails.version =~ RAILS_3
    end

    def rails31?
      ::Rails.version =~ RAILS_31
    end

    def rails2?
      ::Rails.version =~ RAILS_23
    end

    def booted!
      CompassRails.const_set(:BOOTED, true)
    end

    def booted?
      defined?(CompassRails::BOOTED) && CompassRails::BOOTED
    end

    def configuration
      config = Compass::Configuration::Data.new('rails')
      config.extend(Configuration::Default)
      if rails31?
        require "compass-rails/configuration/3_1"
        config.extend(Configuration::Rails3_1)
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
      unless Sass::Util.ap_geq?('3.1.0.beta')
        defined?(Sass::Plugin) && !Sass::Plugin.options[:never_update]
      end
    end

    def rails_compilation_enabled?
      Sass::Util.ap_geq?('3.1.0.beta') && defined?(Sass::Rails) # XXX check if there's some other way(s) to disable the asset pipeline.
    end

    # Rails 2.x projects use this in their compass initializer.
    def initialize!(config = nil)
      check_for_double_boot!
      config ||= Compass.detect_configuration_file(root)
      Compass.add_project_configuration(config, :project_type => :rails)
      Compass.discover_extensions!
      Compass.configure_sass_plugin!
      Compass.handle_configuration_change! if sass_plugin_enabled? || rails_compilation_enabled?
    end

    def configure_rails!(app)
      return unless app.config.respond_to?(:sass)
      app.config.compass.to_sass_engine_options.each do |key, value|
        app.config.sass.send(:"#{key}=", value)
      end
    end

end

Compass::AppIntegration.register(:rails, "::CompassRails")

require "compass-rails/railties"



