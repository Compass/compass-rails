module CompassRails
  module Test
    module RailsHelpers
      VENDORED_RAILS_PATH = File.expand_path('../../fixtures/rails_versions', __FILE__)

    def debug(message)
      puts message if ENV['DEBUG']
    end

    def mkdir_p(dir)
      debug("Creating Directory: #{dir}")
      ::FileUtils.make_dir dir
    end
      
    def new_rails_app(named, version='3.1', &block)
      working_dir = File.expand_path('../../fixtures/rails-temp', __FILE__)
      mkdir_p working_dir
      Dir.chdir(working_dir) do
        generate_rails_app(named, working_dir)

      end
    end

    # Generate a rails application without polluting our current set of requires
    # with the rails libraries. This will allow testing against multiple versions of rails
    # by manipulating the load path.
    def generate_rails_app(name, version='3.1')
      system "rails _#{version}_ new #{name}"
    end

  private
    
    def find_rails_version_executable(version)
      folder = find_rails_version_folder(version)
      File.join(folder, 'bin', 'rails')
    end

    def find_rails_version_folder(version)
      versions = Dir["VENDORED_RAILS_PATH/*"].map {|name| File.basename(name) }
      unless path = versions.sort.detect { |v| v.include?(version)}
        raise "Rails Version Not Found: #{version}"
      end
      File.join(VENDORED_RAILS_PATH, path)
    end
    


    end
  end
end