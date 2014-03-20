
module CompassRails
  module Test
    module RailsHelpers
      include FileHelper
      include DebugHelper
      include CommandHelper
        RAILS_4_0   = "4.0"
        RAILS_3_2   = "3.2"
        RAILS_3_1   = "3.1"

        WORKING_DIR = File.join(ROOT_PATH, 'rails-temp')

        GEMFILES = {
          RAILS_4_0 => GEMFILES_DIR.join("rails40.gemfile").to_s,
          RAILS_3_2 => GEMFILES_DIR.join("rails32.gemfile").to_s,
          RAILS_3_1 => GEMFILES_DIR.join("rails31.gemfile").to_s
        }

        GENERATOR_OPTIONS = {
          RAILS_4_0 => ['-q', '-G', '-O', '--skip-bundle'],
          RAILS_3_2 => ['-q', '-G', '-O', '--skip-bundle'],
          RAILS_3_1 => ['-q', '-G', '-O', '--skip-bundle']
        }

        GENERATOR_COMMAND = {
          RAILS_4_0 => 'new',
          RAILS_3_2 => 'new',
          RAILS_3_1 => 'new'
        }

    def rails_command(options, version)
      debug(Rainbow("Running Rails command with: rails #{options.join(' ')}").foreground(:cyan))
      run_command("rails #{options.join(' ')}", GEMFILES[version])
    end

    # Generate a rails application without polluting our current set of requires
    # with the rails libraries. This will allow testing against multiple versions of rails
    # by manipulating the load path.
    def generate_rails_app(name, version, options=[])
      options += GENERATOR_OPTIONS[version]
      rails_command([GENERATOR_COMMAND[version], name, *options], version)
    end

    def within_rails_app(named, version, asset_pipeline_enabled = true, &block)
      dir = "#{named}-#{version}"
      rm_rf File.join(WORKING_DIR, dir)
      mkdir_p WORKING_DIR
      cd(WORKING_DIR) do
        generate_rails_app(dir, version, asset_pipeline_enabled ? [] : ["-S"])
        cd(dir) do
          yield RailsProject.new(File.join(WORKING_DIR, dir), version, asset_pipeline_enabled)
        end
      end
      rm_rf File.join(WORKING_DIR, dir)
    end

    end
  end
end
