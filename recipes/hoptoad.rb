gem 'hoptoad_notifier'

@strategies << lambda do
  generate 'hoptoad', "--api-key #{SETTINGS['hoptoad']['api_key']}"
end
