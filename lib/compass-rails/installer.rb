module CompassRails
  class Installer < Compass::Installers::ManifestInstaller

    SASS_FILE_REGEX = %r{(.+).(sass|scss)}

    def completed_configuration
      @completed_configuration ||= CompassRails.configuration
    end
    # Will finish
    # def install_stylesheet(from, to, options)
    #   _, name, ext = SASS_FILE_REGEX.match(to)
    #   to = "#{name}.css.#{ext}"
    #   puts to
    #   super(from, to, options)
    # end

  end
end
