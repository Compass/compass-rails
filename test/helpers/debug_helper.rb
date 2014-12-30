module CompassRails
  module Test
    module DebugHelper

      def debug(message)
       puts "#{message}\n"
       $stdout.flush
      end

    end
  end
end
