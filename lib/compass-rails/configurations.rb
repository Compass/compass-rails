RAILS_31 = %r{3.1}
RAILS_23 = %r{2.3}
RAILS_3 = %r{3.0}
if defined?(::Rails)
  case ::Rails.version
  when RAILS_31
  when RAILS_3
  when RAILS_23
end