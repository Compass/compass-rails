module CompassRails
  class Installer < Compass::Installers::ManifestInstaller

    def completed_configuration
      @completed_configuration ||= CompassRails.configuration
    end

  end
end
