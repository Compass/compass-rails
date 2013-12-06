require 'compass-rails/patches/compass'
require 'compass-rails/patches/static_compiler'

module Sass::Script::Functions
  def generated_image_url(path, only_path = nil)
    path = if Compass.configuration.generated_images_dir
             full_path = File.join(Compass.configuration.generated_images_dir, path.value)
             Sass::Script::String.new full_path.sub(File.join('app', 'assets', 'images'), "")[1..-1]
           end

    asset_url(path, Sass::Script::String.new("image"))
  end
end

module Sass::Script::Functions
  include Compass::RailsImageFunctionPatch
end

# Wierd that this has to be re-included to pick up sub-modules. Ruby bug?
class Sass::Script::Functions::EvaluationContext
  include Sass::Script::Functions
end
