require 'appraisal'
require 'appraisal/command'
module CompassRails
  module Test
    module CommandHelper
      include DebugHelper
      GEMFILES_DIR = Pathname.new(ROOT_PATH).join('gemfiles')
      BUNDLER_COMMAND = 'bundle'

      def capture_output
        real_stdout, $stdout = $stdout, StringIO.new
        yield
        debug($stdout.string)
      ensure
        $stdout = real_stdout
      end

      def capture_warning
        real_stderr, $stderr = $stderr, StringIO.new
        yield
        debug($stderr.string)
      ensure
        $stderr = real_stderr
      end

      def run_command(command, gemfile=nil)
        debug("Running: #{command} with gemfile: #{gemfile}".foreground(:cyan))
        ::Appraisal::Command.new(command, gemfile).run
      end

      def bundle
        capture_output do
          run_command(BUNDLER_COMMAND)
        end
      end

    end
  end
end