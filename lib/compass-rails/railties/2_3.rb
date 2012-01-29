#rails 2.x doesn't have railties so gona do this the long way
require "sass/plugin/rack" #unless defined?(Sass::Plugin::Rack)

module ActionController
  class Base
    def process_with_compass(*args)
      Sass::Plugin.rails_controller = self
      begin
        process_without_compass(*args)
      ensure
        Sass::Plugin.rails_controller = nil
      end
    end
    alias_method_chain :process, :compass
  end
end


module Sass::Plugin
  class << self
    attr_accessor :rails_controller
  end
end

module Compass::SassExtensions::Functions::Urls::ImageUrl
  def image_url_with_rails_integration(path, only_path = Sass::Script::Bool.new(false), cache_buster = Sass::Script::Bool.new(true))
    if (@controller = Sass::Plugin.rails_controller) && @controller.respond_to?(:request) && @controller.request
      begin
        if only_path.to_bool
          Sass::Script::String.new image_path(path.value)
        else
          Sass::Script::String.new "url(#{image_path(path.value)})"
        end
      ensure
        @controller = nil
      end
    else
      image_url_without_rails_integration(path, only_path, cache_buster)
    end
  end
  alias_method_chain :image_url, :rails_integration
end


class Sass::Script::Functions::EvaluationContext
  include Sass::Script::Functions
  private
  include ActionView::Helpers::AssetTagHelper
end

unless Compass.detect_configuration_file.nil?
  Compass.add_configuration(CompassRails.configuration)
  CompassRails.initialize!
else
  CompassRails.initialize!(CompassRails.configuration)
end
