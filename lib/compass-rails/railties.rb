if defined?(::Rails)
  if CompassRails.rails2?
    require "compass-rails/railties/2_3"
  elsif CompassRails.rails31? || CompassRails.rails32?
    require "compass-rails/railties/3_1"
  elsif CompassRails.rails3?
    require "compass-rails/railties/3_0"
  else
    $stderr.puts "Unsupported rails environment for compass"
  end
end