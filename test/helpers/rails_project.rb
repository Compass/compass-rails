module CompassRails
  module Test
    class RailsProject
      include FileHelper
      include DebugHelper
      include CommandHelper
      include RailsHelpers


      GEMFILE = 'Gemfile'
      GEMFILE_LOCK = 'Gemfile.lock'
      ENVIRONMENT = 'config/environment.rb'
      COMPASS_CONFIG = 'config/compass.rb'


      attr_reader :directory, :version

      def initialize(directory, version)
        @directory = Pathname.new(directory)
        @version = version
      end

      ## FILE METHODS
        
      def to_s
        directory_name
      end

      def directory_name
        File.basename(directory)
      end

      # COMPASS METHODS

      def install_compass
        install_compass_gem
        touch directory.join(COMPASS_CONFIG)
        inject_at_bottom directory.join(COMPASS_CONFIG), <<-CONFIG
          project_type = :rails
        CONFIG
      end

      def run_compass(command)
        unless File.exist?(directory.join(GEMFILE_LOCK))
          bundle
        end
        run_command("compass #{command}", directory.join(GEMFILE))
      end

      def set_compass(property, value)
        file = directory.join(COMPASS_CONFIG)
        inject_at_bottom(file, "#{property} = #{value}")
      end

      ## GEM METHODS

      def bundle
        capture_output do
          case version
          when RAILS_3_1, RAILS_3
            `bundle install`
          when RAILS_2
            `rake gems:install`
          end
        end
      end

      def has_gem?(name)
        file = case version
        when RAILS_3_1, RAILS_3
          directory.join(GEMFILE)
        when RAILS_2
          directory.join(ENVIRONMENT)
        end
        
        File.read(file).include? "gem '#{name}'"
      end

      def install_gem(name, requirements=nil)
        case version
        when RAILS_3_1, RAILS_3
          add_to_gemfile(name, requirements)
        when RAILS_2
          add_to_environment(name, requirements)
        end
      end

      def install_compass_gem
        install_gem('compass', "'~> 0.12.alpha'")
      end

      private

        ## GEM METHODS

        def add_to_environment(name, requirements)
          file = directory.join(ENVIRONMENT)
          debug("Adding gem #{name} to file: #{file}".foreground(:green))
          if requirements
            gem_string = "  config.gem '#{name}', :version => '#{requirements}'\n"
          else
            gem_string = "  config.gem '#{name}'\n"
          end
          inject_into_file(file, gem_string, :after, "Rails::Initializer.run do |config|")
        end

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