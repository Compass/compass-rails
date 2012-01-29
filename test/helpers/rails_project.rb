module CompassRails
  module Test
    class RailsProject
      include FileHelper
      include DebugHelper
      include CommandHelper
      include RailsHelpers
      include Kernal::Captures


      GEMFILE = 'Gemfile'
      GEMFILE_LOCK = 'Gemfile.lock'
      ENVIRONMENT = 'config/environment.rb'
      COMPASS_CONFIG = 'config/compass.rb'
      APPLICATION_FILE = 'config/application.rb'
      BOOT_FILE = 'config/boot.rb'


      attr_reader :directory, :version

      def initialize(directory, version)
        @directory = Pathname.new(directory)
        @version = version
        configure_for_bundler!
      end

      ## FILE METHODS
        
      def to_s
        directory_name
      end

      def directory_name
        File.basename(directory)
      end

      def has_file?(file)
        File.exist? directory.join(file)
      end

      def screen_file
        case version
        when RAILS_3_1, RAILS_3_2
          return directory.join('app', 'assets', 'stylesheets', 'screen.css.scss')
        when RAILS_2, RAILS_3
          return directory.join('app', 'assets', 'stylesheets','screen.scss')
        end
      end

      def has_screen_file?
        screen_file.exist?
      end

      def has_compass_import?
        File.read(screen_file).include?("compass/reset")
      end

      def has_config?
        directory.join('config', 'compass.rb').exist?
      end

      # RAILS METHODS

      def rails3?
        directory.join(APPLICATION_FILE).exist?
      end

      def rails2?
        directory.join(BOOT_FILE).exist? && !directory.join(APPLICATION_FILE).exist?
      end

      def boots?
        string = 'THIS IS MY RANDOM AWESOME TEST STRING'
        test_string = "puts \"#{string}\""
        matcher = %r{#{string}}
        r = runner(test_string)
        if r =~ matcher
          return true
        else
          return false
        end
      end

      def runner(string)
        case version
        when RAILS_3_1, RAILS_3, RAILS_3_2
          rails_command(['runner', "'#{string}'"], version)
        when RAILS_2
          run_command("script/runner '#{string}'", GEMFILES[version])
        end
      end

      # COMPASS METHODS

      def run_compass(command)
        run_command("compass #{command}", GEMFILES[version])
      end

      def set_compass(property, value)
        file = directory.join(COMPASS_CONFIG)
        unless file.exist?
          touch file
        end
        inject_at_bottom(file, "#{property} = '#{value}'")
      end

      def set_rails(property, value)
        value = if value.is_a?(Symbol)
          "\n    config.#{property} = :#{value}\n"
        else
          "\n    config.#{property} = '#{value}'\n"
        end
        inject_into_file(directory.join(APPLICATION_FILE), value, :after, '# Enable the asset pipeline')
      end

      ## GEM METHODS

      def configure_for_bundler!
        return if [RAILS_3_1, RAILS_3, RAILS_3_2].include?(version)
        bundle = <<-BUNDLER
        class Rails::Boot
          def run
            load_initializer

            Rails::Initializer.class_eval do
              def load_gems
                @bundler_loaded ||= Bundler.require :default, Rails.env
              end
            end

            Rails::Initializer.run(:set_load_path)
          end
        end
        BUNDLER
        inject_into_file(directory.join('config/boot.rb'), bundle, :before, 'Rails.boot!')

        touch directory.join('config/preinitializer.rb')
        preinit = <<-PREINIT
          begin
            require "rubygems"
            require "bundler"
          rescue LoadError
            raise "Could not load the bundler gem. Install it with `gem install bundler`."
          end

          if Gem::Version.new(Bundler::VERSION) <= Gem::Version.new("0.9.24")
            raise RuntimeError, "Your bundler version is too old for Rails 2.3." +
             "Run `gem install bundler` to upgrade."
          end

          begin
            # Set up load paths for all bundled gems
            ENV["BUNDLE_GEMFILE"] = File.expand_path("../../Gemfile", __FILE__)
            Bundler.setup
          rescue Bundler::GemNotFound
            raise RuntimeError, "Bundler couldn't find some gems." +
              "Did you run `bundle install`?"
          end
        PREINIT
        inject_at_bottom(directory.join('config/preinitializer.rb'), preinit)

        touch directory.join('Gemfile')

      end

      def bundle
        raise "NO BUNDLE FOR U"
      end

    private

      ## GEM METHODS

      def add_to_gemfile(name, requirements)
        gemfile = directory.join(GEMFILE)
        debug("Adding gem #{name} to file: #{gemfile}".foreground(:green))
        if requirements
          gem_string = "  gem '#{name}', #{requirements}\n"
        else
          gem_string = "  gem '#{name}'\n"
        end
        inject_at_bottom(gemfile, gem_string)
      end
    end
  end
end