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


      attr_reader :directory, :version, :asset_pipeline_enabled

      def initialize(directory, version, asset_pipeline_enabled = true)
        @directory = Pathname.new(directory)
        @version = version
        @asset_pipeline_enabled = asset_pipeline_enabled
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
        if asset_pipeline_enabled
          return directory.join('app', 'assets', 'stylesheets', 'screen.css.scss')
        else
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
        rails_command(['runner', "'#{string}'"], version)
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
        inject_into_file(directory.join(APPLICATION_FILE), value, :after, 'class Application < Rails::Application')
      end

    private

      ## GEM METHODS

      def add_to_gemfile(name, requirements)
        gemfile = directory.join(GEMFILE)
        debug(Rainbow("Adding gem #{name} to file: #{gemfile}").foreground(:green))
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
