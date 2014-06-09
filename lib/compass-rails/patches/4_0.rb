require 'compass-rails/patches/compass'
require 'compass-rails/patches/sass_importer'
require 'compass-rails/patches/sprite_importer'

module Sass::Script::Functions
  def generated_image_url(path, only_path = nil)
    pathobject = Pathname.new(path.to_s)
    subdirectory = pathobject.dirname.to_s

    cachebust_generated_images(path, subdirectory)
    asset_url(path)
  end

  def cachebust_generated_images(image_path, subdirectory = nil)
    generated_images_path = Rails.root.join(Compass.configuration.generated_images_dir).to_s
    if subdirectory.nil? 
        bust_cache_path = generated_images_path
    else
        bust_cache_path = generated_images_path + "/" + subdirectory
    end
    bust_image_stat_path = generated_images_path + "/" + image_path.to_s

    sprockets_entries = options[:sprockets][:environment].send(:trail).instance_variable_get(:@entries)

    # sprockets_entries.delete(generated_images_path) if sprockets_entries.has_key? generated_images_path
    if sprockets_entries.has_key? generated_images_path
        # sprockets_entries.delete(generated_images_path) 

        # Delete the entries (directories) which cache the files/dirs in a directory
        options[:sprockets][:environment].send(:trail).instance_variable_get(:@entries).delete(bust_cache_path) 

        # Delete the stats (file/dir info) which cache the what kind of file/dir each image is
        options[:sprockets][:environment].send(:trail).instance_variable_get(:@stats).delete(bust_image_stat_path) 
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
