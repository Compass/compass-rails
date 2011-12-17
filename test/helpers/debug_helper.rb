module CompassRails
  module Test
    module DebugHelper

      def debug(message)
       puts "#{message}\n".bright #if ENV['DEBUG']
      end

    end
  end
end