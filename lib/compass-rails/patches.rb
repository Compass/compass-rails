if CompassRails.rails31? || CompassRails.rails32?
  CompassRails.load_rails
  require 'compass-rails/patches/importer'
elsif CompassRails.rails4?
  CompassRails.load_rails
end
