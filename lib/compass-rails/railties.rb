if defined?(::Rails)
  if CompassRails.rails31?
    require "compass-rails/railties/3_1"
  elsif CompassRails.rails3?
    require "compass-rails/railties/3_0"
  elsif CompassRails.rails2?
    require "compass-rails/railties/2_0"
  else
    $stderr.puts "Unsupported rails environment for compass"
  end
else
  $stderr.puts "Rails is not loaded"
end