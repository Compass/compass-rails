if defined?(::Rails)
  if CompassRails.rails31? || CompassRails.rails32?
    require "compass-rails/railties/3_1"
  elsif CompassRails.rails4?
    require "compass-rails/railties/4_0"
  else
    $stderr.puts "Unsupported rails environment for compass"
  end
end
