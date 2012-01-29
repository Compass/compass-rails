module CompassRails
  class Installer < Compass::Installers::ManifestInstaller

    SASS_FILE_REGEX = %r{(.*)(?:\.css)?\.(sass|scss)}

    def completed_configuration
      @completed_configuration ||= CompassRails.configuration
    end

    def install_stylesheet(from, to, options)
      if CompassRails.asset_pipeline_enabled?
        _, name, ext = SASS_FILE_REGEX.match(to).to_a
        to = "#{name}.css.#{ext}"
      end
      super(from, to, options)
    end

  end
end
