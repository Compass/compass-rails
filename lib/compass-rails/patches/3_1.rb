require 'compass-rails/patches/compass'
require 'compass-rails/patches/static_compiler'

Compass::Core::SassExtensions::Functions::Urls::GeneratedImageUrl.module_eval do
  def generated_image_url(path, only_path = nil)
    asset_url(path, Sass::Script::String.new("image"))
  end
end
