require 'compass-rails/patches/sass_importer'
require 'compass-rails/patches/sprite_importer'

module Sass::Script::Functions
  def generated_image_url(path, only_path = nil)
    cachebust_generated_images
    asset_url(path)
  end

  def cachebust_generated_images
    generated_images_path = Rails.root.join(Compass.configuration.generated_images_dir).to_s
    sprockets_entries = options[:sprockets][:environment].send(:trail).instance_variable_get(:@entries)
    sprockets_entries.delete(generated_images_path) if sprockets_entries.has_key? generated_images_path
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

# Wierd that this has to be re-included to pick up sub-modules. Ruby bug?
class Sass::Script::Functions::EvaluationContext
  include Sass::Script::Functions
end
