gem 'hoptoad_notifier'

@strategies << lambda do
  begin
    generate 'hoptoad', "--api-key #{SETTINGS['hoptoad']['api_key']}"
  rescue
  end
end
