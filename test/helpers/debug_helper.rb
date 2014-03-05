module CompassRails
  module Test
    module DebugHelper

      def debug(message)
       puts Rainbow("#{message}\n").bright #if ENV['DEBUG']
       $stdout.flush
      end

    end
  end
end
