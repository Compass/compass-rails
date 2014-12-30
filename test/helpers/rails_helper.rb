module CompassRails
  module Test
    module RailsHelpers
      include FileHelper
      include DebugHelper
      include CommandHelper
        RAILS_4_2   = "4.2"
        RAILS_4_0   = "4.0"
        RAILS_3_2   = "3.2"
        RAILS_3_1   = "3.1"

        WORKING_DIR = File.join(ROOT_PATH, 'rails-temp')

        VERSION_LOOKUP = {
          RAILS_4_2 => %r{^4\.2\.},
          RAILS_4_0 => %r{^4\.0\.},
          RAILS_3_2 => %r{^3\.2\.},
          RAILS_3_1 => %r{^3\.1\.},
        }

        GEMFILES = {
          RAILS_4_2 => GEMFILES_DIR.join("rails42.gemfile").to_s,
          RAILS_4_0 => GEMFILES_DIR.join("rails40.gemfile").to_s,
          RAILS_3_2 => GEMFILES_DIR.join("rails32.gemfile").to_s,
          RAILS_3_1 => GEMFILES_DIR.join("rails31.gemfile").to_s
        }

        GENERATOR_OPTIONS = Hash.new(['-q', '-G', '-O', '--skip-bundle'])

        GENERATOR_COMMAND = Hash.new("new")

    def rails_command(options)
      debug(Rainbow("Running Rails command with: rails #{options.join(' ')}").foreground(:cyan))
      run_command("rails #{options.join(' ')}", GEMFILES[rails_version])
    end

    def rails_version
      @rails_version ||= VERSION_LOOKUP.detect { |version, regex| CompassRails.version_match(regex) }.first
    end

    # Generate a rails application without polluting our current set of requires
    # with the rails libraries. This will allow testing against multiple versions of rails
    # by manipulating the load path.
    def generate_rails_app(name, options=[])
      options += GENERATOR_OPTIONS[rails_version]
      rails_command([GENERATOR_COMMAND[rails_version], name, *options])
    end

    def within_rails_app(named, asset_pipeline_enabled = true, &block)
      dir = "#{named}-#{rails_version}"
      rm_rf File.join(WORKING_DIR, dir)
      mkdir_p WORKING_DIR
      cd(WORKING_DIR) do
        generate_rails_app(dir, asset_pipeline_enabled ? [] : ["-S"])
        cd(dir) do
          yield RailsProject.new(File.join(WORKING_DIR, dir), rails_version, asset_pipeline_enabled)
        end
      end
      rm_rf File.join(WORKING_DIR, dir)
    end

    end
  end
end
