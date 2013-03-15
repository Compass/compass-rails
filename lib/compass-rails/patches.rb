if CompassRails.rails31? || CompassRails.rails32? || CompassRails.rails4?
  unless CompassRails.rails_loaded? 
    CompassRails.load_rails
  end
  require 'compass-rails/patches/importer'
end
