require 'compass-rails/patches/sass_importer'
require 'compass-rails/patches/sprite_importer'

module Sass::Script::Functions
  def generated_image_url(path, only_path = nil)
    asset_url(path)
  end
end

module Compass::RailsImageFunctionPatch
  private
  
  def image_path_for_size(image_file)
    begin
      file = ::Rails.application.assets.find_asset(image_file)
      return file
    rescue ::Sprockets::FileOutsidePaths
      return super(image_file)
    end
  end
end

module Sass::Script::Functions
  include Compass::RailsImageFunctionPatch
end

# Weird that this has to be re-included to pick up sub-modules. Ruby bug?
class Sass::Script::Functions::EvaluationContext
  include Sass::Script::Functions
end
