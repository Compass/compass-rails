module Compass
  module AppIntegration
    module Rails
      extend self
      def initialize!
        Compass::Util.compass_warn("WARNING:  Please remove the call to Compass::AppIntegration::Rails.initialize! from #{caller[0].sub(/:.*$/,'')};\nWARNING:  This is done automatically now. If this is default compass initializer you can just remove the file.")
      end
    end
  end
end
