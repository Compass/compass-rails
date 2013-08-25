if defined?(::Rails)
  if CompassRails.rails31? || CompassRails.rails32?
    require "compass-rails/railties/3_1"
  elsif CompassRails.rails3?
    require "compass-rails/railties/3_0"
  elsif CompassRails.rails4?
    require "compass-rails/railties/4_0"
  elsif CompassRails.rails41?
    require "compass-rails/railties/4_1"
  else
    $stderr.puts "Unsupported rails environment for compass"
  end
end
