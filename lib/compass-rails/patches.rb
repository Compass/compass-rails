if CompassRails.rails31? || CompassRails.rails32?
  unless CompassRails.rails_loaded? 
    CompassRails.load_rails
  end
  require 'compass-rails/patches/importer'
end