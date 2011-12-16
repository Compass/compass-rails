module CompassRails
  module Test
    module RailsHelpers

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


    end
  end
end