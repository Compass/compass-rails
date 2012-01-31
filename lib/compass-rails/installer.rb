module CompassRails
  class Installer < Compass::Installers::ManifestInstaller

    SASS_FILE_REGEX = %r{(.*)(?:\.css)?\.(sass|scss)}

    def completed_configuration
      @completed_configuration ||= CompassRails.configuration
    end

    def install_stylesheet(from, to, options)
      if CompassRails.rails_loaded? && CompassRails.asset_pipeline_enabled?
        _, name, ext = SASS_FILE_REGEX.match(to).to_a
        to = "#{name}.css.#{ext}"
      end
      super(from, to, options)
    end

    def write_configuration_files
      config_file = CompassRails.root.join('config', 'compass.rb')
      unless config_file.exist?
        write_file config_file.to_s, CompassRails.configuration.serialize
      end
    end

    def prepare
      write_configuration_files
    end

  end
end
