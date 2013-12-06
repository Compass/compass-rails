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
