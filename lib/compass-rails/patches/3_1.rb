require 'compass-rails/patches/static_compiler'

module Sass::Script::Functions
  def generated_image_url(path, only_path = nil)
    asset_url(path, Sass::Script::String.new("image"))
  end
end


module Compass::RailsImageFunctionPatch
  private
  
  def image_path_for_size(image_file)
    file = ::Rails.application.assets.find_asset(image_file) rescue nil
    return file || super(image_file)
  end
end

module Sass::Script::Functions
  include Compass::RailsImageFunctionPatch
end

# Wierd that this has to be re-included to pick up sub-modules. Ruby bug?
class Sass::Script::Functions::EvaluationContext
  include Sass::Script::Functions
end
