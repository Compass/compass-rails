Compass::Core::SassExtensions::Functions::ImageSize.class_eval do
  private

  def image_path_for_size(image_file)
    if ::Rails.application.config.assets.compile
      begin
        file = CompassRails.sprockets.find_asset(image_file)
        return file.respond_to?(:pathname) ? file.pathname.to_s : file
      rescue ::Sprockets::FileOutsidePaths
        return super(image_file)
      end
    else
      return image_file if File.exists?(image_file)

      assets_manifest = ::Rails.application.assets_manifest
      file = assets_manifest.assets[image_file]
      if file
        ::Rails.root.join("public", assets_manifest.directory, file)
      else
        super(image_file)
      end
    end
  end
end
